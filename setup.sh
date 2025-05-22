#!/bin/bash
echo "[+] Installing Python dependencies..."
pip3 install --user numpy numba requests beautifulsoup4 psutil torch > /dev/null 2>&1 || {
    echo "[-] Failed to install Python packages"
    echo "Attempting alternative installation..."
    if ! pip3 install --user numpy; then
        echo "Trying pip alternative..."
        python3 -m pip install --user numpy || {
            echo "Critical: Could not install numpy"
            exit 1
        }
    fi
}

echo "[+] Installing Node.js dependencies..."
npm install express > /dev/null 2>&1 || {
    echo "[-] Failed to install Node.js packages"
    exit 1
}

echo "[+] Verifying installations..."
python3 -c "import numpy; print('NumPy version:', numpy.__version__)" || exit 1
node -e "console.log('Node.js ready')" || exit 1

echo "[+] Starting server in background..."
node server.js &
SERVER_PID=$!
sleep 3 # Allow server startup

echo "[+] Running integration tests..."
python3 -c "
import numpy as np
from logic_core import SymbolicProcessor
print('SymbolicProcessor test:', SymbolicProcessor().process(np.array([[1,0],[0,1]])))
"

echo "[+] Server is running on port 3000"
echo "Access: curl http://localhost:3000/status"
wait $SERVER_PID
