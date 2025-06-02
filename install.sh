#!/bin/bash

# Logic Core Complete Installation Script (Termux-Fixed)
# Usage: ./install.sh [--termux | --linux | --firebase | --docker] [--dev]

# -------------------------------
# Initialization
# -------------------------------
set -e
clear
echo "████████████████████████████████████████"
echo "█      Termux-Compatible Installer     █"
echo "████████████████████████████████████████"

# Defaults
MODE="auto"
ENV="production"
INSTALL_DEV=false
TERMUX_MODE=false

# -------------------------------
# Argument Parsing
# -------------------------------
while [[ $# -gt 0 ]]; do
    case $1 in
        --termux) MODE="termux"; TERMUX_MODE=true ;;
        --linux) MODE="linux" ;;
        --firebase) MODE="firebase" ;;
        --docker) MODE="docker" ;;
        --dev) INSTALL_DEV=true ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# -------------------------------
# Environment Detection
# -------------------------------
if [ "$MODE" == "auto" ]; then
    if [[ $(uname -o) == *Android* ]]; then
        MODE="termux"
        TERMUX_MODE=true
    elif command -v firebase &>/dev/null; then
        MODE="firebase"
    elif command -v docker &>/dev/null; then
        MODE="docker"
    else
        MODE="linux"
    fi
fi

echo "[*] Installation mode: $MODE"
[ "$TERMUX_MODE" = true ] && echo "[*] Termux mode enabled"

# -------------------------------
# Dependency Lists
# -------------------------------
CORE_DEPS=(
    "express"
    "cors"
    "node-localstorage"
    "tesseract.js"
)

TERMUX_DEPS=(
    "puppeteer-core"  # Using core version for Termux
    "@tensorflow/tfjs"  # Pure JS version
)

LINUX_DEPS=(
    "puppeteer"
    "@tensorflow/tfjs-node"
)

FIREBASE_DEPS=(
    "firebase-admin"
    "@google-cloud/functions-framework"
)

DEV_DEPS=(
    "firebase-tools"
    "nodemon"
    "jest"
)

# -------------------------------
# Installation Functions
# -------------------------------
prepare_termux() {
    echo "[*] Setting up Termux environment..."
    termux-setup-storage <<< "y"  # Auto-accept storage prompt
    mkdir -p ~/logic-core
    cd ~/logic-core
    
    # Configure npm
    npm config set prefix '~/.npm-global'
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    
    # Install system packages
    pkg update -y && pkg upgrade -y
    pkg install -y \
        nodejs git openssh \
        termux-api clang python make \
        tesseract
}

install_termux() {
    prepare_termux
    
    echo "[*] Installing Termux-compatible dependencies..."
    npm install --omit=optional \
        ${TERMUX_DEPS[@]} \
        ${CORE_DEPS[@]} \
        --cache=~/logic-core/.npm-cache
    
    if [ "$INSTALL_DEV" = true ]; then
        npm install --save-dev ${DEV_DEPS[@]}
    fi

    # Configure environment
    echo "export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true" >> ~/.bashrc
    echo "export HEADLESS_MODE=true" >> ~/.bashrc
    echo "export TFJS_BACKEND=cpu" >> ~/.bashrc
    source ~/.bashrc
}

install_linux() {
    echo "[*] Installing Linux dependencies..."
    sudo apt update && sudo apt install -y \
        build-essential python3 \
        chromium-browser libatk-bridge2.0-0 \
        libgtk-3-0 libnss3 libxss1 \
        libasound2 libgbm1 tesseract-ocr \
        libtesseract-dev

    npm install ${LINUX_DEPS[@]} ${CORE_DEPS[@]}
    
    if [ "$INSTALL_DEV" = true ]; then
        npm install --save-dev ${DEV_DEPS[@]}
    fi
}

install_firebase() {
    echo "[*] Installing Firebase dependencies..."
    npm install -g firebase-tools
    firebase login
    
    npm install ${LINUX_DEPS[@]} ${CORE_DEPS[@]} ${FIREBASE_DEPS[@]}
    
    if [ "$INSTALL_DEV" = true ]; then
        npm install --save-dev ${DEV_DEPS[@]}
    fi
    
    cd cloud-functions && npm install && cd ..
}

install_docker() {
    echo "[*] Preparing Docker installation..."
    docker build -t logic-core . -f Dockerfile \
        --build-arg INSTALL_DEV=$INSTALL_DEV
}

# -------------------------------
# Main Installation
# -------------------------------
case $MODE in
    "termux") install_termux ;;
    "linux") install_linux ;;
    "firebase") install_firebase ;;
    "docker") install_docker ;;
    *) echo "Invalid mode"; exit 1 ;;
esac

# -------------------------------
# Post-Installation
# -------------------------------
echo "[*] Finalizing setup..."

if [ "$TERMUX_MODE" = true ]; then
    cat > .env.local <<EOL
BROWSER_MODE=headless
REMOTE_BROWSER_WS=
TFJS_BACKEND=cpu
EOL
else
    cat > .env.local <<EOL
BROWSER_MODE=local
BROWSER_PATH=$(which chromium-browser || which chromium)
TFJS_BACKEND=node
EOL
fi

# -------------------------------
# Verification
# -------------------------------
echo "[*] Verifying installation..."
node -e "
try {
    if (process.env.TFJS_BACKEND === 'cpu') {
        require('@tensorflow/tfjs');
        console.log('✓ TensorFlow.js (CPU) working');
    } else {
        require('@tensorflow/tfjs-node');
        console.log('✓ TensorFlow.js (Node) working');
    }
    console.log('✓ Core packages installed');
} catch(e) {
    console.error('Verification failed:', e);
    process.exit(1);
}"

# -------------------------------
# Completion
# -------------------------------
echo "████████████████████████████████████████"
echo "█      Installation Successful!       █"
echo "█                                    █"
echo "█  Next Steps:                       █"
echo "█  1. For browser functionality:     █"

if [ "$TERMUX_MODE" = true ]; then
echo "█    - Set up remote Chrome:         █"
echo "█      google-chrome --remote-debugging-port=9222"
echo "█    - Add to .env.local:            █"
echo "█      REMOTE_BROWSER_WS=ws://your-ip:9222/..."
fi

echo "█  2. Start development:             █"
echo "█     npm run dev                    █"
echo "████████████████████████████████████████"

exit 0