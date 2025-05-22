#!/bin/bash
# Install dependencies
pip3 install numpy numba requests beautifulsoup4 psutil torch || {
    echo "Failed to install Python dependencies"
    exit 1
}

npm install express || {
    echo "Failed to install Node.js dependencies"
    exit 1
}

# Start the server
node server.js &
SERVER_PID=$!

# Register cleanup
trap "kill $SERVER_PID" EXIT

# Run tests
python3 -c "
import numpy as np
from logic_core import SymbolicProcessor

processor = SymbolicProcessor()
test_data = np.random.rand(100, 2)
print('Test result:', processor.process(test_data, mode='orthogonal'))
"

wait $SERVER_PID
