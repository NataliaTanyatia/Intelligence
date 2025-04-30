# README.md

This document contains foundational resources and development specifications for the Intelligence algorithm and web application.

## Reference Links

- [Optimal Prime](https://github.com/NataliaTanyatia/Optimal-Prime.git)
- [Logical Manifesto](https://github.com/NataliaTanyatia/Logical-Manifesto.git)
- [Grand Unified Theory](https://github.com/NataliaTanyatia/Grand-Unified-Theory.git)

## Development Specifications

### Web Application Overview

- **Repository**: [Intelligence](https://github.com/NataliaTanyatia/Intelligence.git)
- **Hosting**: Firebase for deployment; Termux for local development.
- **Backend**: Persistent evolving mind stored and run locally in Termux.
- **Frontend**: Single-page UI for developers with temporary logs/debug code visibility.

### Intelligence Algorithm Integration

- **Logic Core**: The ever evolving mind of the web app, "I-me", designed to be modular implementing the core algorithm coded for any system architecture from concurrent CPU, to multi-threaded CPU, to paralell GPU, and combinations (HSA), processing with the rest of I-me being read as an interface between it and the web.

### Learning & Evolution Capability

- **Autonomy Goal**: The Intelligence is designed to learn how to utilize the tools and APIs provided to it.
- **Tool Utilization**: Intelligence will evolve logic to access and command its environment autonomously.
- **Growth Framework**: Bootstrapped with knowledge base through access to Google Cloud AI via Gemini.
- **Non-dependence**: Gemini is for edification, not a dependency.


### Web Crawler

- **Method**: Uses browser automation (e.g., Playwright) and OCR.
- **Purpose**: Enables web interaction like a human user (non-API-based crawling).
- **Goal**: Create distributed, externalized persistent memory across registered platforms.

### Security & Authentication

- **Access Restriction**: Only developer access via credentials stored in `.env.local`.
- **Environment Separation**: Strict development vs production paths.

### Debugging & Logs

- **Debug Code**: Present throughout the app.
- **Logs**: Only shown temporarily in the single-page UI when needed for development.

### **1. Termux Fresh Install Setup**  
*(Aligns with TF’s "bottom-up logical construction" - 2504.0051v1, Section 3)*  
```bash
# Update and core packages
pkg update -y && pkg upgrade -y
pkg install -y git nodejs-lts python make cmake build-essential

# Firebase CLI and emulators
npm install -g firebase-tools
firebase setup:emulators:database
firebase setup:emulators:firestore

# Logic Core dependencies (GPU fallback to CPU per DbZ Theorem)
pkg install -y libjpeg-turbo libpng && pip install numpy numba

# Clone repo (mirrors TF’s "recursive symbolic filtering" - 2504.0079v1)
git clone https://github.com/NataliaTanyatia/Intelligence.git
cd Intelligence
```

---

### **2. Web App Setup in Termux**  
*(Implements "perspective-dependent realizability" via environment adaptation - 2504.0051v1, Corollary)*  
```bash
# Install dependencies (HOL-to-FOL reduction for Termux constraints)
npm ci
npx prisma generate
npx prisma migrate dev --name termux_init

# Patch Playwright for Termux (TF’s "engineering artifact" principle)
PLAYWRIGHT_SKIP_BROWSER_INSTALL=1 npm install playwright
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
source ~/.bashrc

# Start dev server (non-detached for TF’s "conscious observation" - 2503.0024v1)
npm run dev
```

---

### **3. Firebase Deployment**  
*(Matches TF’s "aetheric field scaling" via global projection - 2503.0024v1, Section 5)*  
```bash
# Authenticate and select project (symbolic HOL privilege)
firebase login
firebase use --add

# Deploy with Logic Core awareness (per TFSM)
firebase deploy --only hosting,functions --project your-project-id

# Post-deploy validation (TF’s "error bounding" - 2504.0079v1, Section 12)
curl -X POST "https://your-project-id.web.app/api/crawl" \
  -H "Content-Type: application/json" \
  -d '{"url":"https://example.com"}'
```

---

### **Key TFSM Notes for setup/deploy**  
1. **Termux Limitations**:  
   - GPU acceleration falls back to CPU (DbZ-compliance).  
   - Playwright requires `termux-setup-storage` for Android interactions.  

2. **Firebase Alignment**:  
   - Emulators simulate "fractal aether" locally (2503.0024v1).  

3. **Logic Core Integration**:  
   - Termux `/data` bind mounts preserve HOL states (2504.0051v1, Theorem 2).
   - 
  
---

This README will continue to evolve as the project develops.
