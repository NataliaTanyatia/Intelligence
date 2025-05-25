#!/bin/bash
# Enhanced installation script with error recovery

# Configuration
PYTHON_DEPS=("numpy" "numba" "requests" "beautifulsoup4" "psutil" "torch")
NODE_DEPS=("express")
LOG_FILE="logic_core_install.log"
PYTHON_CMD="python3"
NPM_CMD="npm"

# Initialize log
echo "Logic Core Installation Log - $(date)" > $LOG_FILE
exec 3>&1 4>&2  # Save original stdout/stderr
exec > >(tee -a $LOG_FILE) 2>&1

# Function declarations
function install_python_deps() {
    echo "Installing Python dependencies..."
    local retry_count=0
    local max_retries=3
    
    while [ $retry_count -lt $max_retries ]; do
        if $PYTHON_CMD -m pip install --upgrade pip wheel setuptools >> $LOG_FILE 2>&1; then
            for dep in "${PYTHON_DEPS[@]}"; do
                echo "Installing $dep..."
                if ! $PYTHON_CMD -m pip install $dep >> $LOG_FILE 2>&1; then
                    echo "Failed to install $dep, attempting fallback..."
                    $PYTHON_CMD -m pip install --no-deps $dep >> $LOG_FILE 2>&1 || {
                        echo "Critical failure installing $dep"
                        return 1
                    }
                fi
            done
            return 0
        else
            ((retry_count++))
            echo "Pip upgrade failed, retry $retry_count/$max_retries"
            sleep $((retry_count * 2))
        fi
    done
    
    echo "Maximum retries exceeded for pip installation"
    return 1
}

function install_node_deps() {
    echo "Installing Node.js dependencies..."
    if ! $NPM_CMD install "${NODE_DEPS[@]}" >> $LOG_FILE 2>&1; then
        echo "Trying with --legacy-peer-deps..."
        $NPM_CMD install --legacy-peer-deps "${NODE_DEPS[@]}" >> $LOG_FILE 2>&1 || {
            echo "Failed to install Node.js dependencies"
            return 1
        }
    fi
    return 0
}

function verify_install() {
    echo "Verifying installation..."
    $PYTHON_CMD -c "
import sys
try:
    import numpy, numba, requests, bs4, psutil, torch
    print('Python verification successful')
except ImportError as e:
    print(f'Python verification failed: {e}')
    sys.exit(1)
" || return 1

    $NPM_CMD list "${NODE_DEPS[@]}" >/dev/null 2>&1 || {
        echo "Node.js verification failed"
        return 1
    }
    
    return 0
}

# Main execution
if install_python_deps && install_node_deps && verify_install; then
    echo "Starting Logic Core server..."
    nohup $PYTHON_CMD -c "
from logic_core import SymbolicProcessor
print('SymbolicProcessor initialized:', SymbolicProcessor() is not None)
" >> $LOG_FILE 2>&1 &
    
    nohup node server.js >> $LOG_FILE 2>&1 &
    echo "System started successfully. Server log: $LOG_FILE"
else
    echo "Installation failed. See $LOG_FILE for details"
    exec 1>&3 3>&-  # Restore stdout
    exec 2>&4 4>&-  # Restore stderr
    tail -n 20 $LOG_FILE
    exit 1
fi

# Restore output streams
exec 1>&3 3>&-
exec 2>&4 4>&-