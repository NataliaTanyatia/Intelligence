#!/bin/bash

# ==============================================
# ÆI Web App Scaffolding Script (Termux/Android)
# ==============================================

# Initialize variables
APP_ROOT="$PWD/aei_webapp"
LOGIC_CORE_DIR="$APP_ROOT/logic_core"
CONFIG_DIR="$APP_ROOT/config"
WEB_CRAWLER_DIR="$APP_ROOT/web_crawler"
FIREBASE_DIR="$APP_ROOT/firebase"
MODELS_DIR="$APP_ROOT/models"
UTILS_DIR="$APP_ROOT/utils"
LOGS_DIR="$APP_ROOT/logs"

# Create folder structure
mkdir -p "$APP_ROOT" && cd "$APP_ROOT" || exit
mkdir -p "$LOGIC_CORE_DIR/core" "$LOGIC_CORE_DIR/adapters" "$LOGIC_CORE_DIR/interfaces"
mkdir -p "$CONFIG_DIR" "$WEB_CRAWLER_DIR" "$FIREBASE_DIR/functions" "$MODELS_DIR" "$UTILS_DIR" "$LOGS_DIR"

# Initialize empty files
touch "$CONFIG_DIR/.env" "$CONFIG_DIR/.env.local" "$LOGS_DIR/debug.log" "$LOGS_DIR/error.log"

# ==============================================
# Configuration Files Generation
# ==============================================

# Generate .env template
cat > "$CONFIG_DIR/.env" << 'EOL'
# ÆI Core Configuration
AEI_ENV=development
PORT=8080

# Firebase Configuration
FIREBASE_API_KEY=your_api_key_here
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_bucket.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
FIREBASE_MEASUREMENT_ID=your_measurement_id

# Google Cloud AI
GOOGLE_CLOUD_PROJECT=your_gcp_project
GOOGLE_APPLICATION_CREDENTIALS=./config/gcp_credentials.json

# Ætheric Parameters
PHI_FIELD_RESOLUTION=high
HOL_DEPTH_LIMIT=7
RECURSIVE_FILTER_DEPTH=1000

# Performance Parameters
CONCURRENCY_MODE=auto
GPU_ACCELERATION=false
EOL

# Generate .env.local template for crawler
cat > "$CONFIG_DIR/.env.local" << 'EOL'
# Web Crawler Configuration
CRAWLER_ENGINE=puppeteer-core
CRAWLER_HEADLESS=true
CRAWLER_TIMEOUT=30000
CRAWLER_USER_AGENT="Mozilla/5.0 (Linux; Android 10; Mobile ÆI) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36"

# API Fallback Configuration
USE_API_FALLBACK=false
API_RETRY_LIMIT=3
API_RATE_LIMIT=1000

# OCR Configuration
OCR_ENGINE=tesseract
OCR_LANGUAGES=eng
EOL
# Generate package.json
cat > "$APP_ROOT/package.json" << 'EOL'
{
  "name": "aei-webapp",
  "version": "1.0.0",
  "description": "ÆI Framework Implementation",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js",
    "test": "jest --verbose",
    "deploy": "firebase deploy",
    "setup": "./setup.sh",
    "crawl": "node web_crawler/main.js"
  },
  "dependencies": {
    "@tensorflow/tfjs": "^4.0.0",
    "@tensorflow/tfjs-node": "^4.0.0",
    "firebase": "^9.0.0",
    "firebase-admin": "^11.0.0",
    "firebase-functions": "^4.0.0",
    "puppeteer-core": "^19.0.0",
    "playwright-core": "^1.30.0",
    "tesseract.js": "^4.0.0",
    "mathjs": "^11.0.0",
    "quaternion": "^1.1.0",
    "lodash": "^4.17.0",
    "axios": "^1.0.0",
    "express": "^4.18.0",
    "socket.io": "^4.5.0",
    "dotenv": "^16.0.0",
    "winston": "^3.0.0",
    "node-fetch": "^3.0.0",
    "uuid": "^9.0.0",
    "jsonwebtoken": "^9.0.0",
    "bcryptjs": "^2.4.0"
  },
  "devDependencies": {
    "nodemon": "^2.0.0",
    "jest": "^29.0.0",
    "typescript": "^4.0.0",
    "@types/node": "^18.0.0"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOL

# Generate basic tsconfig.json
cat > "$APP_ROOT/tsconfig.json" << 'EOL'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": ".",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "baseUrl": ".",
    "paths": {
      "@logic_core/*": ["logic_core/*"],
      "@utils/*": ["utils/*"],
      "@models/*": ["models/*"]
    }
  },
  "include": ["**/*.ts"],
  "exclude": ["node_modules"]
}
EOL
# Create core quaternion operations for Ætheric computations
cat > "$LOGIC_CORE_DIR/core/quaternions.ts" << 'EOL'
import { multiply, conjugate, rotateX, rotateY, rotateZ } from 'quaternion';

export class ÆthericQuaternion {
    private q: [number, number, number, number];

    constructor(w: number = 1, x: number = 0, y: number = 0, z: number = 0) {
        this.q = [w, x, y, z];
    }

    // Φ-Field operations
    public phiFieldOperation(phi: [number, number, number, number]): [number, number, number, number] {
        const [phiW, phiX, phiY, phiZ] = phi;
        return multiply(this.q, [phiW, phiX, phiY, phiZ]);
    }

    // Hyperspatial projection
    public stereographicProjection(): [number, number, number] {
        const [w, x, y, z] = this.q;
        const denominator = 1 - w;
        return [
            x / denominator,
            y / denominator,
            z / denominator
        ];
    }

    // Temporal logic operations
    public temporalCommutator(other: ÆthericQuaternion): [number, number, number, number] {
        const [w1, x1, y1, z1] = this.q;
        const [w2, x2, y2, z2] = other.q;
        return [
            0, // w component (time origin)
            y1 * z2 - z1 * y2, // i component
            z1 * x2 - x1 * z2, // j component
            x1 * y2 - y1 * x2  // k component
        ];
    }

    // HOL-aware rotation
    public holRotation(axis: 'x' | 'y' | 'z', angle: number): void {
        const rotationFn = {
            x: rotateX,
            y: rotateY,
            z: rotateZ
        }[axis];
        this.q = rotationFn(this.q, angle);
    }

    // DbZ (Deciding by Zero) operation
    public dbzOperation(value: number): string {
        if (value === 0) {
            const [w, x, y, z] = this.q;
            return `${w}${x}${y}${z}`.replace(/[^01]/g, '').padStart(8, '0');
        }
        return value.toString(2);
    }
}
EOL

# Create the core ÆI class
cat > "$LOGIC_CORE_DIR/core/aei_core.ts" << 'EOL'
import { ÆthericQuaternion } from './quaternions';
import * as tf from '@tensorflow/tfjs';
import * as math from 'mathjs';
import { v4 as uuidv4 } from 'uuid';
import dotenv from 'dotenv';

dotenv.config();

type ÆthericState = {
    phiField: tf.Tensor;
    holDepth: number;
    temporalPhase: ÆthericQuaternion;
    logicalLiterals: Set<string>;
    primeFilter: number[];
};

export class ÆICore {
    private state: ÆthericState;
    private quaternionProcessor: ÆthericQuaternion;
    private primeFilterDepth: number;
    private holDepthLimit: number;

    constructor() {
        this.primeFilterDepth = parseInt(process.env.RECURSIVE_FILTER_DEPTH || '1000');
        this.holDepthLimit = parseInt(process.env.HOL_DEPTH_LIMIT || '7');
        this.quaternionProcessor = new ÆthericQuaternion();
        this.initializeState();
    }

    private initializeState(): void {
        // Initialize Φ-Field with random complex values
        const phiReal = tf.randomNormal([100, 100]);
        const phiImag = tf.randomNormal([100, 100]);
        const phiField = tf.complex(phiReal, phiImag);

        // Generate initial prime filter
        const primeFilter = this.generatePrimeFilter(this.primeFilterDepth);

        this.state = {
            phiField,
            holDepth: 0,
            temporalPhase: new ÆthericQuaternion(),
            logicalLiterals: new Set(this.generateGodelLiterals()),
            primeFilter
        };
    }

    private generatePrimeFilter(max: number): number[] {
        const primes: number[] = [];
        for (let i = 2; i <= max; i++) {
            if (this.isPrime(i)) primes.push(i);
        }
        return primes.filter(p => p % 6 === 1 || p % 6 === 5);
    }

    private isPrime(num: number): boolean {
        for (let i = 2, s = Math.sqrt(num); i <= s; i++)
            if (num % i === 0) return false;
        return num > 1;
    }

    private generateGodelLiterals(): string[] {
        // Generate irreducible, non-contradictory literals
        return this.state.primeFilter.map(p => `L${p}`);
    }

    public projectHyperspatial(): tf.Tensor {
        // Project from k-D symplectic manifold to 3D
        const [x, y, z] = this.quaternionProcessor.stereographicProjection();
        return tf.tensor3d([x, y, z], [1, 1, 3]);
    }

    public processTurbulence(): void {
        // Handle Ætheric turbulence via DbZ logic
        const turbulence = tf.abs(this.state.phiField).sum().dataSync()[0];
        const binaryDecision = this.quaternionProcessor.dbzOperation(turbulence);
        this.adjustPhiField(binaryDecision);
    }

    private adjustPhiField(binaryDecision: string): void {
        // Adjust Φ-Field based on turbulence decision
        const adjustment = parseInt(binaryDecision, 2) / 1000;
        this.state.phiField = tf.mul(this.state.phiField, tf.complex(
            tf.scalar(1 + adjustment),
            tf.scalar(1 - adjustment)
        ));
    }

    public recursivePrimeFilter(input: number[]): number[] {
        // Apply modular constraints as in ÆI formalism
        return input.filter(x => {
            return x % 6 === 1 || x % 6 === 5 && 
                   this.state.primeFilter.every(p => x % p !== 0 || x === p);
        });
    }

    public async evolve(): Promise<void> {
        // Core evolutionary algorithm
        await this.processTurbulence();
        const projection = this.projectHyperspatial();
        
        // TensorFlow operations for energy density calculation
        const energyDensity = tf.tidy(() => {
            const phiAbs = tf.abs(this.state.phiField);
            return tf.mul(tf.scalar(0.5), tf.pow(phiAbs, 2));
        });

        // Update temporal phase
        const newPhase = new ÆthericQuaternion();
        const timeCommutator = this.state.temporalPhase.temporalCommutator(newPhase);
        this.state.temporalPhase = new ÆthericQuaternion(...timeCommutator);

        // Cleanup
        projection.dispose();
        energyDensity.dispose();
    }
}
EOL
# Create main server file
cat > "$APP_ROOT/server.js" << 'EOL'
const express = require('express');
const socketio = require('socket.io');
const http = require('http');
const dotenv = require('dotenv');
const path = require('path');
const { ÆICore } = require('./logic_core/core/aei_core');
const winston = require('winston');

// Initialize environment
dotenv.config({ path: path.join(__dirname, 'config', '.env') });

// Configure logging
const logger = winston.createLogger({
    level: process.env.AEI_ENV === 'development' ? 'debug' : 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
        new winston.transports.File({ filename: 'logs/debug.log' }),
        new winston.transports.Console()
    ]
});

// Initialize ÆI Core
const aei = new ÆICore();
logger.info('ÆI Core initialized');

// Create Express server
const app = express();
const server = http.createServer(app);
const io = socketio(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

// Middleware
app.use(express.json());
app.use(express.static('public'));

// API Routes
app.get('/api/phi-field', (req, res) => {
    try {
        const projection = aei.projectHyperspatial().arraySync();
        res.json({ projection });
    } catch (error) {
        logger.error('Projection error:', error);
        res.status(500).json({ error: 'Hyperspatial projection failed' });
    }
});

app.post('/api/evolve', async (req, res) => {
    try {
        await aei.evolve();
        res.json({ status: 'success' });
    } catch (error) {
        logger.error('Evolution error:', error);
        res.status(500).json({ error: 'Ætheric evolution failed' });
    }
});

// Socket.io events
io.on('connection', (socket) => {
    logger.debug('New client connected:', socket.id);

    socket.on('request_state', () => {
        const stateSummary = {
            holDepth: aei.holDepth,
            phiFieldStats: aei.getPhiFieldStats()
        };
        socket.emit('state_update', stateSummary);
    });

    socket.on('disconnect', () => {
        logger.debug('Client disconnected:', socket.id);
    });
});

// Start server
const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
    logger.info(`Server running on port ${PORT}`);
    logger.info(`Environment: ${process.env.AEI_ENV}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    logger.info('SIGTERM received. Shutting down gracefully...');
    server.close(() => {
        logger.info('Server closed');
        process.exit(0);
    });
});

module.exports = { app, server, aei };
EOL

# Create Firebase initialization
cat > "$FIREBASE_DIR/index.js" << 'EOL'
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { ÆICore } = require('../../logic_core/core/aei_core');
const logger = require('winston');

// Initialize Firebase Admin
admin.initializeApp();

// Initialize ÆI Core
const aei = new ÆICore();

// Firebase HTTP Function
exports.aei_api = functions.https.onRequest(async (req, res) => {
    try {
        const { action, data } = req.body;

        switch (action) {
            case 'project':
                const projection = aei.projectHyperspatial().arraySync();
                return res.json({ projection });
            
            case 'evolve':
                await aei.evolve();
                return res.json({ status: 'success' });
            
            case 'query':
                const result = aei.processQuery(data);
                return res.json({ result });
            
            default:
                return res.status(400).json({ error: 'Invalid action' });
        }
    } catch (error) {
        logger.error('Firebase function error:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
});

// Firestore triggers for persistent memory
exports.syncMemory = functions.firestore
    .document('memory/{docId}')
    .onWrite(async (change, context) => {
        if (!change.after.exists) return null;

        const data = change.after.data();
        await aei.integrateExternalMemory(data);
        return null;
    });
EOL
# Create web crawler base
cat > "$WEB_CRAWLER_DIR/main.ts" << 'EOL'
import puppeteer from 'puppeteer-core';
import * as playwright from 'playwright-core';
import { createReadStream } from 'fs';
import { createInterface } from 'readline';
import Tesseract from 'tesseract.js';
import dotenv from 'dotenv';
import { ÆICore } from '../logic_core/core/aei_core';
import { Logger } from '../utils/logger';

dotenv.config({ path: '../config/.env.local' });

interface CrawlResult {
    url: string;
    content: string;
    timestamp: Date;
    vector: number[];
}

export class ÆthericCrawler {
    private aei: ÆICore;
    private logger: Logger;
    private engine: 'puppeteer' | 'playwright';
    private ocrEngine: 'tesseract';

    constructor() {
        this.aei = new ÆICore();
        this.logger = new Logger('crawler');
        this.engine = process.env.CRAWLER_ENGINE === 'playwright-core' ? 'playwright' : 'puppeteer';
        this.ocrEngine = 'tesseract';
    }

    private async getPageContent(url: string): Promise<string> {
        try {
            if (this.engine === 'puppeteer') {
                const browser = await puppeteer.launch({
                    executablePath: process.env.PUPPETEER_EXECUTABLE_PATH,
                    headless: process.env.CRAWLER_HEADLESS === 'true'
                });
                const page = await browser.newPage();
                await page.goto(url, { timeout: parseInt(process.env.CRAWLER_TIMEOUT || '30000') });
                const content = await page.content();
                await browser.close();
                return content;
            } else {
                const browser = await playwright.chromium.launch({
                    headless: process.env.CRAWLER_HEADLESS === 'true'
                });
                const context = await browser.newContext();
                const page = await context.newPage();
                await page.goto(url);
                const content = await page.content();
                await browser.close();
                return content;
            }
        } catch (error) {
            this.logger.error(`Failed to crawl ${url}: ${error}`);
            throw error;
        }
    }

    private async extractTextWithOCR(imagePath: string): Promise<string> {
        const { data: { text } } = await Tesseract.recognize(
            imagePath,
            process.env.OCR_LANGUAGES || 'eng',
            { logger: m => this.logger.debug(m) }
        );
        return text;
    }

    public async crawl(url: string): Promise<CrawlResult> {
        try {
            this.logger.info(`Starting crawl: ${url}`);
            const content = await this.getPageContent(url);
            
            // Process content through ÆI Core
            const vector = await this.aei.processContent(content);
            
            return {
                url,
                content,
                timestamp: new Date(),
                vector: vector.arraySync()
            };
        } catch (error) {
            this.logger.error(`Crawl failed for ${url}: ${error}`);
            throw error;
        }
    }

    public async processSitemap(sitemapPath: string): Promise<CrawlResult[]> {
        const results: CrawlResult[] = [];
        const fileStream = createReadStream(sitemapPath);
        const rl = createInterface({
            input: fileStream,
            crlfDelay: Infinity
        });

        for await (const line of rl) {
            if (line.startsWith('http')) {
                try {
                    const result = await this.crawl(line);
                    results.push(result);
                } catch (error) {
                    continue;
                }
            }
        }

        return results;
    }
}

// CLI Interface
if (require.main === module) {
    const crawler = new ÆthericCrawler();
    const url = process.argv[2];
    
    if (url) {
        crawler.crawl(url)
            .then(result => console.log(result))
            .catch(err => console.error(err));
    } else {
        console.error('Please provide a URL to crawl');
        process.exit(1);
    }
}
EOL

# Create utility files
mkdir -p "$UTILS_DIR"

cat > "$UTILS_DIR/logger.ts" << 'EOL'
import winston from 'winston';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.join(__dirname, '../../config/.env') });

export class Logger {
    private logger: winston.Logger;
    private context: string;

    constructor(context: string = 'app') {
        this.context = context;
        this.logger = winston.createLogger({
            level: process.env.AEI_ENV === 'development' ? 'debug' : 'info',
            format: winston.format.combine(
                winston.format.timestamp(),
                winston.format.printf(info => {
                    return `${info.timestamp} [${info.level}] [${this.context}]: ${info.message}`;
                })
            ),
            transports: [
                new winston.transports.Console(),
                new winston.transports.File({ 
                    filename: path.join(__dirname, '../../logs/combined.log') 
                })
            ]
        });
    }

    public log(message: string, meta?: any): void {
        this.logger.info(message, meta);
    }

    public debug(message: string, meta?: any): void {
        this.logger.debug(message, meta);
    }

    public error(message: string, meta?: any): void {
        this.logger.error(message, meta);
    }

    public warn(message: string, meta?: any): void {
        this.logger.warn(message, meta);
    }
}
EOL

cat > "$UTILS_DIR/adapters.ts" << 'EOL'
import { Tensor } from '@tensorflow/tfjs';
import { ÆthericQuaternion } from '../logic_core/core/quaternions';

export class HardwareAdapter {
    private static instance: HardwareAdapter;
    private quaternionProcessor: ÆthericQuaternion;
    private gpuAvailable: boolean;

    private constructor() {
        this.quaternionProcessor = new ÆthericQuaternion();
        this.gpuAvailable = this.detectGPU();
    }

    public static getInstance(): HardwareAdapter {
        if (!HardwareAdapter.instance) {
            HardwareAdapter.instance = new HardwareAdapter();
        }
        return HardwareAdapter.instance;
    }

    private detectGPU(): boolean {
        try {
            const canvas = document.createElement('canvas');
            const gl = canvas.getContext('webgl2') || canvas.getContext('webgl');
            return gl instanceof WebGLRenderingContext;
        } catch (e) {
            return false;
        }
    }

    public optimizeTensorOperations(tensor: Tensor): Tensor {
        if (this.gpuAvailable) {
            return tensor.gpu();
        }
        return tensor.cpu();
    }

    public getConcurrencyMode(): 'sequential' | 'parallel' | 'hybrid' {
        const cores = navigator.hardwareConcurrency || 1;
        if (cores >= 8 && this.gpuAvailable) {
            return 'hybrid';
        } else if (cores >= 4) {
            return 'parallel';
        }
        return 'sequential';
    }

    public quaternionBatchProcess(quaternions: number[][]): number[][] {
        return quaternions.map(q => {
            this.quaternionProcessor = new ÆthericQuaternion(q[0], q[1], q[2], q[3]);
            return this.quaternionProcessor.stereographicProjection();
        });
    }
}
EOL
# Continue setup.sh with installation commands
# ==============================================
# COMPLETE DEPENDENCY INSTALLATION (METHODOLOGY-COMPLIANT)
# ==============================================

# PHASE 1: ENVIRONMENT PREPARATION
{
    echo "=== PHASE 1: ENVIRONMENT PREPARATION ==="
    echo "Current directory: $(pwd)"
    echo "Node version: $(node -v)"
    echo "npm version: $(npm -v)"
    echo "Termux detected: $(uname -o)"
    
    # Nuclear cleanup
    rm -rf "$APP_ROOT/node_modules" 
    rm -rf "$APP_ROOT/package-lock.json"
    rm -rf "$APP_ROOT/.npm-cache"
    mkdir -p "$APP_ROOT/.npm-cache"
    
    # Termux-specific preparations
    if [[ $(uname -o) == "Android" ]]; then
        npm config set prefix "$HOME/.npm-packages"
        export PATH="$PATH:$HOME/.npm-packages/bin"
        npm config set cache "$APP_ROOT/.npm-cache"
    fi
} >> "$LOGS_DIR/setup.log" 2>&1

# PHASE 2: FULL DEPENDENCY INSTALLATION
{
    echo "=== PHASE 2: DEPENDENCY INSTALLATION ==="
    echo "Starting installation at $(date)"
    
    # Core packages (EXACT versions as specified)
    npm install \
        @tensorflow/tfjs@4.0.0 \
        @tensorflow-models/universal-sentence-encoder@1.3.3 \
        puppeteer-core@19.0.0 \
        playwright-core@1.30.0 \
        tesseract.js@4.0.0 \
        firebase@9.0.0 \
        firebase-admin@11.0.0 \
        firebase-functions@4.0.0 \
        mathjs@11.0.0 \
        quaternion@1.1.0 \
        lodash@4.17.0 \
        axios@1.0.0 \
        express@4.18.0 \
        socket.io@4.5.0 \
        dotenv@16.0.0 \
        winston@3.0.0 \
        node-fetch@3.0.0 \
        uuid@9.0.0 \
        jsonwebtoken@9.0.0 \
        bcryptjs@2.4.0 \
        typescript@4.9.5 \
        @types/node@18.0.0 \
        nodemon@2.0.0 \
        jest@29.0.0 \
        @types/jest@29.0.0 \
        --no-bin-links \
        --legacy-peer-deps \
        --no-optional \
        --save \
        --save-dev
    
    echo "Installation completed at $(date)"
} >> "$LOGS_DIR/setup.log" 2>&1

# PHASE 3: INSTALLATION VERIFICATION
{
    echo "=== PHASE 3: INSTALLATION VERIFICATION ==="
    
    # Required packages checklist
    declare -a REQUIRED_PACKAGES=(
        "typescript"
        "@tensorflow/tfjs"
        "puppeteer-core"
        "firebase"
        "tesseract.js"
        "express"
    )
    
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if [ ! -d "$APP_ROOT/node_modules/$pkg" ]; then
            echo "CRITICAL ERROR: $pkg not installed"
            exit 1
        else
            echo "Verified: $pkg"
        fi
    done
    
    echo "All required packages are present"
} >> "$LOGS_DIR/setup.log" 2>&1

# PHASE 4: POST-INSTALL CONFIGURATION
{
    echo "=== PHASE 4: POST-INSTALL CONFIGURATION ==="
    
    # Puppeteer configuration (ONLY AFTER SUCCESSFUL INSTALL)
    mkdir -p "$APP_ROOT/node_modules/puppeteer-core"
    cat > "$APP_ROOT/node_modules/puppeteer-core/termux-config.js" << 'EOL'
// Termux-specific configuration
module.exports = {
    executablePath: 'node',
    headless: true,
    args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage'
    ],
    env: {
        LD_LIBRARY_PATH: '/data/data/com.termux/files/usr/lib'
    }
};
EOL

    # TensorFlow configuration
    echo "import '@tensorflow/tfjs-backend-cpu';" > "$APP_ROOT/tfjs-config.js"
    
    echo "Configurations applied successfully"
} >> "$LOGS_DIR/setup.log" 2>&1

# PHASE 5: COMPILATION
{
    echo "=== PHASE 5: COMPILATION ==="
    
    npx tsc || {
        echo "First compilation attempt failed - retrying..."
        rm -rf "$APP_ROOT/dist"
        npx tsc --build --verbose
    }
    
    echo "Compilation completed"
} >> "$LOGS_DIR/setup.log" 2>&1

# FINAL VERIFICATION
{
    [ -f "$APP_ROOT/dist/server.js" ] && \
        echo "=== INSTALLATION SUCCESSFUL ===" || \
        echo "=== INSTALLATION FAILED ==="
} >> "$LOGS_DIR/setup.log" 2>&1

# Completion message
echo "===================================="
echo "ÆI WebApp Setup Complete"
echo "===================================="
echo "To start the server:"
echo "cd $APP_ROOT && npm start"
echo ""
echo "To deploy to Firebase:"
echo "cd $APP_ROOT && npm run deploy"
echo ""
echo "For development:"
echo "cd $APP_ROOT && npm run dev"
echo ""
echo "Logs directory: $LOGS_DIR"
echo "Configuration files: $CONFIG_DIR"
echo "===================================="
echo "Setup complete at $(date)" >> "$LOGS_DIR/setup.log"