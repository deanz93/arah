#!/usr/bin/env bash
# Arah Platform — First-time developer setup script
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[arah]${NC} $1"; }
warning() { echo -e "${YELLOW}[warn]${NC} $1"; }
error()   { echo -e "${RED}[error]${NC} $1"; exit 1; }

echo ""
echo "  🧭  Arah Platform Setup"
echo "  ========================"
echo ""

# ── Check prerequisites ────────────────────────────────────────────
info "Checking prerequisites..."

command -v node >/dev/null 2>&1 || error "Node.js not found. Install from https://nodejs.org (v20 LTS)"
command -v npm  >/dev/null 2>&1 || error "npm not found."
command -v git  >/dev/null 2>&1 || error "git not found."
command -v docker >/dev/null 2>&1 || warning "Docker not found. Backend services won't run locally."
command -v java >/dev/null 2>&1 || warning "Java not found. Android builds won't work."

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
  error "Node.js v20+ required. Found v$(node -v)"
fi

info "Node $(node -v) ✓"

# ── Install root dependencies (Husky) ─────────────────────────────
info "Installing root dependencies (Husky, lint-staged)..."
npm install
npm run prepare

# ── Mobile app ────────────────────────────────────────────────────
info "Installing mobile app dependencies..."
cd apps/mobile
npm install
cd ../..

# ── Web app ───────────────────────────────────────────────────────
info "Installing web app dependencies..."
cd apps/web
npm install
cd ../..

# ── API Gateway ───────────────────────────────────────────────────
info "Installing API Gateway dependencies..."
cd services/api-gateway
npm install
cd ../..

# ── Firebase Functions ────────────────────────────────────────────
info "Installing Firebase Functions dependencies..."
cd functions
npm install
cd ..

# ── Environment files ─────────────────────────────────────────────
info "Setting up environment files..."

if [ ! -f apps/mobile/.env ]; then
  cp apps/mobile/.env.example apps/mobile/.env
  warning "Created apps/mobile/.env — fill in your service URLs"
fi

if [ ! -f apps/web/.env.local ]; then
  cp apps/web/.env.local.example apps/web/.env.local
  warning "Created apps/web/.env.local — fill in your Firebase config"
fi

if [ ! -f services/api-gateway/.env ]; then
  cp services/api-gateway/.env.example services/api-gateway/.env
  warning "Created services/api-gateway/.env — fill in Firebase Admin SDK credentials"
fi

if [ ! -f infra/.env ]; then
  cp infra/.env.example infra/.env
  warning "Created infra/.env — fill in secrets before running docker-compose"
fi

# ── Firebase config check ─────────────────────────────────────────
if [ ! -f apps/mobile/android/app/google-services.json ]; then
  warning "Missing: apps/mobile/android/app/google-services.json"
  warning "Download from Firebase Console → Project Settings → Android app"
fi

if [ ! -f apps/mobile/ios/GoogleService-Info.plist ]; then
  warning "Missing: apps/mobile/ios/GoogleService-Info.plist"
  warning "Download from Firebase Console → Project Settings → iOS app"
fi

# ── Backend services ──────────────────────────────────────────────
echo ""
info "Backend services are run via Docker. To start:"
echo ""
echo "  # Full stack"
echo "  cd infra && docker-compose up"
echo ""
echo "  # Individual services"
echo "  cd services/routing   && docker-compose up   # Valhalla routing"
echo "  cd services/geocoding && docker-compose up   # Nominatim geocoding"
echo "  cd services/tile-server && docker-compose up # Map tiles"
echo ""
echo "  # First-time tile build (downloads OSM data)"
echo "  cd services/routing    && bash scripts/build-tiles.sh"
echo "  cd services/tile-server && bash scripts/build-tiles.sh"
echo ""

# ── Done ──────────────────────────────────────────────────────────
echo ""
info "Setup complete! Next steps:"
echo ""
echo "  1. Fill in .env files (see warnings above)"
echo "  2. Download Firebase config files (google-services.json / GoogleService-Info.plist)"
echo "  3. Start backend: cd infra && docker-compose up"
echo "  4. Run mobile app: cd apps/mobile && npx react-native run-android"
echo "  5. Run web app:    cd apps/web && npm run dev"
echo ""
echo "  📖 Full guide: docs/bmad/06-dev-setup.md"
echo ""
