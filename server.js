const { spawn } = require('child_process');
const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

// 1. Core Services Initialization
const coreServices = {
    symbolicProcessor: null,
    envScanner: null,
    webEngager: null
};

function initCoreServices() {
    return new Promise((resolve) => {
        const initScript = spawn('python3', ['-c', `
from logic_core import SymbolicProcessor, EnvironmentScanner
from logic_core.interface.web_engagement import WebEngager
print({
    'symbolicProcessor': True,
    'envScanner': True,
    'webEngager': True
})
        `]);
        
        initScript.stdout.on('data', (data) => {
            Object.assign(coreServices, JSON.parse(data));
            resolve();
        });
    });
}

// 2. Autonomous Endpoint Learning
app.use(express.json());
app.post('/learn', async (req, res) => {
    const learner = spawn('python3', ['-c', `
from logic_core.interface.system_scan.endpoint_discovery import EndpointScanner
from logic_core.interface.web_engagement.dynamic_engager import DynamicWebEngager
scanner = EndpointScanner("${path.join(__dirname)}")
engager = DynamicWebEngager("${req.body.baseUrl || 'http://localhost:3000'}")
print({
    'staticEndpoints': scanner.extract_endpoints(),
    'dynamicEndpoints': engager.discover()
})
    `]);
    
    learner.stdout.pipe(res);
    learner.stderr.pipe(process.stderr);
});

// 3. Intelligent Processing Endpoint
app.post('/process', (req, res) => {
    const { mode, data, constraints } = req.body;
    const processor = spawn('python3', ['-c', `
import numpy as np
from logic_core import SymbolicProcessor
from logic_core.intelligence.constraints import ConstraintEngine

processor = SymbolicProcessor()
${constraints ? constraints.map(c => 
    `processor.add_constraint(ConstraintEngine().get('${c}'))`).join('\n') : ''}

result = processor.process(
    np.array(${JSON.stringify(data)}), 
    "${mode || 'auto'}"
)
print({
    'result': result.tolist() if hasattr(result, 'tolist') else result,
    'constraintsUsed': ${constraints ? JSON.stringify(constraints) : '[]'}
})
    `]);
    
    processor.stdout.pipe(res);
    processor.stderr.pipe(process.stderr);
});

// 4. Web Interaction Proxy
app.get('/interact/:objective', (req, res) => {
    const engager = spawn('python3', ['-c', `
from logic_core.interface.web_engagement.dynamic_engager import DynamicWebEngager
engager = DynamicWebEngager()
print(engager.intelligent_request("${req.params.objective}"))
    `]);
    
    engager.stdout.pipe(res);
    engager.stderr.pipe(process.stderr);
});

// 5. System Status Endpoints
app.get('/status', (req, res) => {
    res.json({
        services: coreServices,
        endpoints: {
            learn: 'POST /learn',
            process: 'POST /process',
            interact: 'GET /interact/:objective'
        }
    });
});

// Startup Sequence
initCoreServices().then(() => {
    app.listen(PORT, () => {
        console.log(`
        ██╗      ██████╗  ██████╗ ██╗ ██████╗     ██████╗ ██████╗ ██████╗ ███████╗
        ██║     ██╔═══██╗██╔════╝ ██║██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝
        ██║     ██║   ██║██║  ███╗██║██║         ██║     ██║   ██║██████╔╝█████╗  
        ██║     ██║   ██║██║   ██║██║██║         ██║     ██║   ██║██╔══██╗██╔══╝  
        ███████╗╚██████╔╝╚██████╔╝██║╚██████╗    ╚██████╗╚██████╔╝██║  ██║███████╗
        ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝ ╚═════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
        `);
        console.log(`Logic Core active on port ${PORT}`);
        console.log(`Access the interactive API at http://localhost:${PORT}/status`);
    });
});
