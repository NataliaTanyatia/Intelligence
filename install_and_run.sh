#!/bin/bash
# Universal Installer & Runner for Logic Core
# Version 2.0 - Architecture-Aware with Full Edge Case Handling

set -eo pipefail
trap 'cleanup $?' EXIT

# Configuration
LOG_FILE="logic_core_install.log"
PYTHON_DEPS=(
    "numpy>=1.21.0"
    "numba>=0.55.0"
    "requests>=2.26.0"
    "beautifulsoup4>=4.10.0"
    "psutil>=5.8.0"
    "torch>=1.10.0"
)
NODE_DEPS=("express>=4.17.1")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Error handling
cleanup() {
    if [ "$1" -ne 0 ]; then
        echo -e "${RED}Error occurred during execution. Check ${LOG_FILE} for details.${NC}"
    fi
    if [ -n "$SERVER_PID" ]; then
        kill "$SERVER_PID" 2>/dev/null || true
    fi
}

# Platform detection
detect_architecture() {
    case "$(uname -m)" in
        x86_64)  echo "x64" ;;
        aarch64) echo "arm64" ;;
        arm*)    echo "arm" ;;
        *)       echo "unknown" ;;
    esac
}

# Dependency checks
check_python() {
    if ! command -v python3 &>/dev/null; then
        echo -e "${RED}Python 3 not found. Installing...${NC}"
        if command -v apt-get &>/dev/null; then
            sudo apt-get update && sudo apt-get install -y python3 python3-pip
        elif command -v yum &>/dev/null; then
            sudo yum install -y python3 python3-pip
        elif command -v brew &>/dev/null; then
            brew install python
        else
            echo -e "${RED}Could not install Python automatically. Please install Python 3 manually.${NC}"
            exit 1
        fi
    fi
}

check_node() {
    if ! command -v node &>/dev/null; then
        echo -e "${RED}Node.js not found. Installing...${NC}"
        if command -v apt-get &>/dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v yum &>/dev/null; then
            curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo -E bash -
            sudo yum install -y nodejs
        elif command -v brew &>/dev/null; then
            brew install node
        else
            echo -e "${RED}Could not install Node.js automatically. Please install Node.js LTS manually.${NC}"
            exit 1
        fi
    fi
}

# Installation functions
install_python_deps() {
    local arch_suffix=""
    case "$(detect_architecture)" in
        arm64) arch_suffix="--prefer-binary" ;;
        arm)   arch_suffix="--no-binary :all:" ;;
    esac

    echo -e "${YELLOW}Installing Python dependencies...${NC}"
    pip3 install --upgrade pip wheel | tee -a "$LOG_FILE"
    
    for dep in "${PYTHON_DEPS[@]}"; do
        echo -e "${YELLOW}Installing $dep...${NC}"
        if [[ "$dep" == "torch"* ]]; then
            pip3 install "$dep" --extra-index-url https://download.pytorch.org/whl/cpu $arch_suffix | tee -a "$LOG_FILE"
        else
            pip3 install "$dep" $arch_suffix | tee -a "$LOG_FILE"
        fi
        
        # Verify installation
        if ! pip3 show "${dep%%[>=]*}" &>/dev/null; then
            echo -e "${RED}Failed to install $dep${NC}"
            exit 1
        fi
    done
}

install_node_deps() {
    echo -e "${YELLOW}Installing Node.js dependencies...${NC}"
    npm init -y | tee -a "$LOG_FILE"
    
    for dep in "${NODE_DEPS[@]}"; do
        echo -e "${YELLOW}Installing $dep...${NC}"
        if ! npm install "$dep" --save | tee -a "$LOG_FILE"; then
            echo -e "${RED}Failed to install $dep${NC}"
            exit 1
        fi
    done
}

# System checks
verify_environment() {
    echo -e "${YELLOW}Verifying system architecture...${NC}"
    ARCH=$(detect_architecture)
    echo "Detected architecture: $ARCH"
    
    if [ "$ARCH" == "unknown" ]; then
        echo -e "${YELLOW}Warning: Unsupported architecture. Some features may be limited.${NC}"
    fi

    check_python
    check_node
    
    echo -e "${YELLOW}Checking Python version...${NC}"
    python3 -c "import sys; assert sys.version_info >= (3, 8), 'Python 3.8+ required'" || {
        echo -e "${RED}Python 3.8 or higher is required${NC}"
        exit 1
    }
}

# Main execution
run_system() {
    echo -e "${YELLOW}Starting Logic Core...${NC}"
    node server.js >> "$LOG_FILE" 2>&1 &
    SERVER_PID=$!
    
    # Wait for server to start
    for i in {1..10}; do
        if curl -s http://localhost:3000/status >/dev/null; then
            break
        fi
        sleep 1
    done
    
    echo -e "${GREEN}System is running!${NC}"
    echo -e "Access the API at ${YELLOW}http://localhost:3000/status${NC}"
    echo -e "View logs at ${YELLOW}$LOG_FILE${NC}"
    
    # Run tests
    echo -e "${YELLOW}Running system tests...${NC}"
    python3 -c "
import numpy as np
from logic_core import SymbolicProcessor
print('SymbolicProcessor test:', SymbolicProcessor().process(np.array([[1,0],[0,1]]), 'orthogonal'))
" | tee -a "$LOG_FILE"
    
    wait "$SERVER_PID"
}

# Main flow
main() {
    echo -e "${GREEN}Logic Core Installation Started${NC}"
    echo "Detailed log: $LOG_FILE"
    
    verify_environment
    install_python_deps
    install_node_deps
    run_system
}

main