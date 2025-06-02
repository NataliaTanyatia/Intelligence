cat > logic-core/debug/logger.js << 'EOL'
const fs = require('fs');
const path = require('path');
const { format } = require('util');

module.exports = function(env = 'development') {
    const logFile = path.join(process.env.LOG_PATH || './logs', 'system.log');
    
    if (!fs.existsSync(path.dirname(logFile))) {
        fs.mkdirSync(path.dirname(logFile), { recursive: true });
    }

    return {
        log: (message, ...args) => {
            const entry = `[${new Date().toISOString()}] INFO: ${format(message, ...args)}\n`;
            fs.appendFileSync(logFile, entry);
            if (env === 'development') console.log(entry.trim());
        },
        error: (message, ...args) => {
            const entry = `[${new Date().toISOString()}] ERROR: ${format(message, ...args)}\n`;
            fs.appendFileSync(logFile, entry);
            console.error(entry.trim());
        },
        warn: (message, ...args) => {
            const entry = `[${new Date().toISOString()}] WARN: ${format(message, ...args)}\n`;
            fs.appendFileSync(logFile, entry);
            if (env === 'development') console.warn(entry.trim());
        },
        debug: (message, ...args) => {
            if (env === 'development') {
                const entry = `[${new Date().toISOString()}] DEBUG: ${format(message, ...args)}\n`;
                fs.appendFileSync(logFile, entry);
                console.debug(entry.trim());
            }
        }
    };
};
EOL
cat > server.js << 'EOL'
const express = require('express');
const cors = require('cors');
const path = require('path');
const LogicCore = require('./logic-core/core/intelligence');
const createLogger = require('./logic-core/debug/logger');

const app = express();
const port = process.env.PORT || 3000;
const logger = createLogger(process.env.NODE_ENV);
const logicCore = new LogicCore();

app.use(cors({
    origin: process.env.CORS_ORIGINS || '*',
    methods: ['GET', 'POST', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

if (process.env.SERVE_WEB === 'true') {
    app.use(express.static(path.join(__dirname, 'web-interface/public')));
}

app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'operational',
        timestamp: Date.now(),
        environment: process.env.NODE_ENV || 'development'
    });
});

app.post('/process', async (req, res) => {
    try {
        const result = await logicCore.process(req.body);
        res.status(200).json({
            success: true,
            data: result,
            timestamp: Date.now()
        });
    } catch (error) {
        logger.error('Processing error:', error);
        res.status(500).json({
            success: false,
            error: error.message,
            timestamp: Date.now()
        });
    }
});

app.use((err, req, res, next) => {
    logger.error('Unhandled error:', err.stack);
    res.status(500).json({
        success: false,
        error: 'Internal server error',
        timestamp: Date.now()
    });
});

app.listen(port, () => {
    logger.log(`Server running on port ${port}`);
    logicCore.on('ready', () => {
        logger.log('Logic Core initialized and ready');
    });
});
EOL