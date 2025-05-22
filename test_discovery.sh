#!/bin/bash
echo "Testing Endpoint Discovery..."
python3 -c "
from logic_core.interface.system_scan.endpoint_discovery import EndpointScanner
scanner = EndpointScanner('.')
print('Discovered endpoints:', scanner.extract_endpoints())
"

echo -e "\nTesting Dynamic Learning..."
python3 -c "
from logic_core.interface.web_engagement.dynamic_engager import DynamicWebEngager
engager = DynamicWebEngager('http://localhost:3000')
print('Optimal path for "login":', engager.optimize_path('login'))
print('Intelligent request:', engager.intelligent_request('data'))
"

echo -e "\nAccess Node.js discovery route:"
curl http://localhost:3000/discover
