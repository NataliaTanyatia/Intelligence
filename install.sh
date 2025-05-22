#!/bin/bash
echo ">>> Updating Termux and installing core dependencies..."
pkg update -y
pkg install nodejs git libjpeg-turbo zlib libpng jq -y

echo ">>> Initializing Node.js project..."
npm init -y

echo ">>> Installing NPM dependencies..."
npm install next react react-dom typescript \
  prisma @prisma/client \
  bcrypt next-auth @auth/prisma-adapter \
  tesseract.js playwright \
  tailwindcss postcss autoprefixer \
  eslint eslint-config-next \
  sharp \
  firebase @firebase/app @firebase/auth @firebase/firestore

echo ">>> Installing TailwindCSS config..."
npx tailwindcss init -p

echo ">>> Writing tailwind.config.js..."
cat <<EOF > tailwind.config.js
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx}",
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

echo ">>> Creating globals.css..."
mkdir -p app
cat <<EOF > app/globals.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

echo ">>> Creating .env file..."
cat <<EOF > .env
DATABASE_URL="file:./dev.db"
NEXTAUTH_SECRET="$(openssl rand -base64 32)"
NEXTAUTH_URL="http://localhost:3000"
EOF

echo ">>> Initializing Prisma..."
npx prisma init

echo ">>> Generating Prisma client..."
npx prisma generate

echo ">>> Running Prisma migration..."
npx prisma migrate dev --name init

echo ">>> Seeding admin user..."
npx tsx scripts/seed-admin.ts

echo ">>> Installing Playwright browser..."
npx playwright install

echo ">>> Firebase (optional) setup..."
echo "Run 'firebase login' and 'firebase init' manually if needed for Firebase Hosting/Firestore support."

echo ">>> Setup complete. You can now run the app with:"
echo "npm run dev"
jq '.scripts = {
  "dev": "next dev",
  "build": "next build",
  "start": "next start",
  "lint": "next lint",
  "seed": "tsx scripts/seed-admin.ts",
  "migrate": "prisma migrate dev --name init",
  "generate": "prisma generate"
}' package.json > package.tmp.json && mv package.tmp.json package.json
cat <<EOF > tsconfig.json
{
  "compilerOptions": {
    "target": "es6",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve"
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOF
cat <<EOF > .gitignore
node_modules
.next
.env
dist
*.log
*.sqlite
generated_files
EOF
cat <<EOF > next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    appDir: true
  }
}

module.exports = nextConfig
EOF
