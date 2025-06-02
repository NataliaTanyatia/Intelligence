#!/bin/bash

# Logic Core Run Script
# Usage: ./run.sh [--dev | --prod | --firebase | --docker] [--remote-browser]

# -------------------------------
# Initialization
# -------------------------------
set -e
clear
echo "████████████████████████████████████████"
echo "█      Logic Core Runner              █"
echo "████████████████████████████████████████"

# Defaults
MODE="dev"
REMOTE_BROWSER=false
NODE_ENV="development"
USE_FIREBASE=false
USE_DOCKER=false

# -------------------------------
# Argument Parsing
# -------------------------------
while [[ $# -gt 0 ]]; do
    case $1 in
        --prod) MODE="prod"; NODE_ENV="production" ;;
        --firebase) USE_FIREBASE=true ;;
        --docker) USE_DOCKER=true ;;
        --remote-browser) REMOTE_BROWSER=true ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# -------------------------------
# Environment Detection
# -------------------------------
if [[ $(uname -o) == *Android* ]]; then
    IS_TERMUX=true
else
    IS_TERMUX=false
fi

# -------------------------------
# Configuration
# -------------------------------
if [ -f .env.local ]; then
    export $(grep -v '^#' .env.local | xargs)
fi

if [ "$REMOTE_BROWSER" = true ]; then
    export BROWSER_MODE="remote"
elif [ "$IS_TERMUX" = true ] && [ "$BROWSER_MODE" != "remote" ]; then
    export BROWSER_MODE="headless"
fi

# -------------------------------
# Run Functions
# -------------------------------
run_local() {
    echo "[*] Starting $NODE_ENV server..."
    NODE_ENV=$NODE_ENV node server.js
}

run_firebase() {
    echo "[*] Starting Firebase emulators..."
    firebase emulators:start --only functions,hosting
}

run_docker() {
    echo "[*] Starting Docker container..."
    docker run -it --rm \
        -p 3000:3000 \
        -e NODE_ENV=$NODE_ENV \
        -e BROWSER_MODE=$BROWSER_MODE \
        -e REMOTE_BROWSER_WS=$REMOTE_BROWSER_WS \
        logic-core
}

run_with_browser() {
    if [ "$BROWSER_MODE" = "remote" ]; then
        echo "[*] Using remote browser at: $REMOTE_BROWSER_WS"
    elif [ "$BROWSER_MODE" = "headless" ]; then
        echo "[*] Running in headless mode"
    else
        echo "[*] Using local browser"
    fi
    
    $1
}

# -------------------------------
# Main Execution
# -------------------------------
case $MODE in
    "dev")
        if [ "$USE_FIREBASE" = true ]; then
            run_with_browser run_firebase
        elif [ "$USE_DOCKER" = true ]; then
            run_docker
        else
            run_with_browser run_local
        fi
        ;;
    "prod")
        if [ "$USE_FIREBASE" = true ]; then
            echo "[*] Deploying to Firebase..."
            firebase deploy
        elif [ "$USE_DOCKER" = true ]; then
            echo "[*] Starting production Docker container..."
            docker run -d --restart always \
                -p 3000:3000 \
                -e NODE_ENV=production \
                --name logic-core \
                logic-core
        else
            echo "[*] Starting production server..."
            NODE_ENV=production pm2 start server.js --name "logic-core"
        fi
        ;;
    *)
        echo "Invalid mode"; exit 1 ;;
esac

# -------------------------------
# Completion
# -------------------------------
echo "████████████████████████████████████████"
echo "█      Service Started Successfully   █"
echo "█                                    █"

if [ "$IS_TERMUX" = true ]; then
echo "█  Termux Notes:                      █"
echo "█  - Running in $BROWSER_MODE mode       █"
if [ "$BROWSER_MODE" = "headless" ]; then
echo "█  - For browser functionality:      █"
echo "█    Run with --remote-browser flag  █"
echo "█    and set REMOTE_BROWSER_WS in    █"
echo "█    .env.local                      █"
fi
fi

if [ "$MODE" = "prod" ]; then
echo "█  Production Notes:                  █"
if [ "$USE_DOCKER" = false ] && [ "$USE_FIREBASE" = false ]; then
echo "█  - PM2 process started             █"
echo "█  - Monitor with: pm2 logs          █"
fi
fi

echo "████████████████████████████████████████"

exit 0