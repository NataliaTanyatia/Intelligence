## **setup.sh**:Usage

### Termux (Android)
```bash
pkg install nodejs git
git clone <repository>
cd <repository>
./setup.sh --termux
npm start
```

### Firebase Deployment
```bash
firebase login
./setup.sh --prod --firebase
npm run deploy
```

### Local Development
```bash
./setup.sh --dev
npm run dev
```

## Configuration
Edit `.env.local` for environment-specific settings
EOL

# Set executable permissions
chmod +x scripts/deploy.sh
chmod +x setup.sh

# -------------------------------
# Installation Summary
# -------------------------------
echo "████████████████████████████████████████"
echo "█       SETUP COMPLETE                █"
echo "████████████████████████████████████████"
echo "█                                      █"
echo "█  Next Steps:                         █"
echo "█  1. Configure .env.local             █"
echo "█  2. Install dependencies:            █"
echo "█     npm install                      █"
echo "█  3. Start development:               █"
echo "█     npm run dev                      █"
echo "█  4. Deploy when ready:               █"
echo "█     npm run deploy                   █"
echo "█                                      █"
echo "████████████████████████████████████████"

### Final Notes:
1. Combine all parts sequentially into a single `setup.sh` file
2. Make executable: `chmod +x setup.sh`
3. Run with desired options:
   ```bash
   # Development (Termux/Local)
   ./setup.sh --dev

   # Production (Firebase)
   ./setup.sh --prod --firebase

   # Reconfigure existing setup
   ./setup.sh --reconfigure
   ```

The complete system includes:
- Environment-aware architecture
- Hybrid CPU/GPU processing
- Secure memory persistence
- Web crawling with OCR
- Firebase and local deployment
- Comprehensive error handling
- Multi-platform support (Termux, Linux, Cloud)

# **install.sh**: Usage Instructions

1. **Make the script executable**:
   ```bash
   chmod +x install.sh
   ```

2. **Installation Options**:

   | Command | Description |
   |---------|-------------|
   | `./install.sh --termux` | Android/Termux installation |
   | `./install.sh --linux` | Linux desktop/server |
   | `./install.sh --firebase` | Firebase Cloud setup |
   | `./install.sh --docker` | Docker container build |
   | `./install.sh --gpu` | Enable GPU support (Linux only) |
   | `./install.sh --dev` | Include development tools |

3. **Examples**:
   ```bash
   # Termux with dev tools
   ./install.sh --termux --dev

   # Linux with GPU support
   ./install.sh --linux --gpu

   # Firebase production setup
   ./install.sh --firebase
   ```

### **Key Features**

1. **Automatic Environment Detection**:
   - Detects Termux, Firebase, Docker, or Linux automatically

2. **GPU Support**:
   - Installs CUDA toolkit and TF.js GPU bindings when requested

3. **Development Mode**:
   - Optional dev tools (Nodemon, Jest, Firebase CLI)

4. **Platform-Specific Optimizations**:
   - Termux: Chromium path fixes
   - Linux: Proper sandboxing config
   - Firebase: Cloud Functions setup

5. **Verification Steps**:
   - Checks Node, npm, and Firebase CLI versions
   - Validates critical dependencies

This script handles all installation scenarios from your requirements while maintaining security and cross-platform compatibility.

### Post-Installation:

For remote browser setup:
1. On a desktop computer:
   ```bash
   google-chrome --remote-debugging-port=9222
   ```
2. In Termux, add to `.env.local`:
   ```
   REMOTE_BROWSER_WS=ws://your-desktop-ip:9222/devtools/browser/[ID]
   ```

### **run.sh**: Usage Info

1. **Multi-Environment Support**:
   ```bash
   ./run.sh --dev          # Local development
   ./run.sh --prod         # Production mode
   ./run.sh --firebase     # Firebase emulators
   ./run.sh --docker       # Docker container
   ```

2. **Browser Mode Handling**:
   ```bash
   ./run.sh --remote-browser  # Connect to remote Chrome instance
   ```

3. **Termux Optimization**:
   - Auto-detects Termux environment
   - Defaults to headless mode
   - Provides clear instructions for remote browser setup

4. **Production Ready**:
   ```bash
   ./run.sh --prod         # PM2 process (Linux)
   ./run.sh --prod --docker # Docker container
   ./run.sh --prod --firebase # Firebase deploy
   ```

5. **Intelligent Configuration**:
   - Automatically loads `.env.local`
   - Detects Termux environment
   - Handles browser modes seamlessly

### Usage Examples:

1. **Basic Development (Termux/Linux)**:
   ```bash
   ./run.sh --dev
   ```

2. **With Remote Browser**:
   ```bash
   ./run.sh --dev --remote-browser
   ```

3. **Firebase Emulators**:
   ```bash
   ./run.sh --dev --firebase
   ```

4. **Production Deployment**:
   ```bash
   ./run.sh --prod --docker
   ```

5. **Termux with Remote Chrome**:
   ```bash
   # On desktop (run first):
   google-chrome --remote-debugging-port=9222

   # In Termux:
   ./run.sh --dev --remote-browser
   ```

The script includes clear status messages and automatically handles environment-specific requirements. For Termux users, it provides helpful guidance about browser functionality limitations and solutions.