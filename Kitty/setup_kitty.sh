#!/usr/bin/env bash

# ==============================================================================
# KITTY TERMINAL - TESTED RAM-DISK BUILD & INSTALLATION SCRIPT
# ==============================================================================
# Description: Automates compiling Kitty terminal using the 'make linux-package' 
#              method inside a RAM disk to maximize speed and reliability.
# Target OS:   Ubuntu/Debian-based distributions
# ==============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# Terminal text colors for beautiful logging
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

clear
echo -e "${GREEN}"
echo "  _  ___ _ _            _   _ ____  "
echo " | |/ (_) | |_ _  _    | | | |  _ \ "
echo " | ' <| | __| || || |   | |_| | |_) |"
echo " |_|\_\_|\__|\_,_|| |    \___/|  __/ "
echo "                |__/          |_|    "
echo -e "${NC}"
echo "=============================================================================="

# ------------------------------------------------------------------------------
# STEP 1: Create and Mount the RAM Disk
# ------------------------------------------------------------------------------
log_info "Creating and mounting a 2GB RAM disk (tmpfs) at /tmp/kitty_yolo..."
sudo mkdir -p /tmp/kitty_yolo
# Mount if not already mounted
if ! mountpoint -q /tmp/kitty_yolo; then
    sudo mount -t tmpfs -o size=2G tmpfs /tmp/kitty_yolo
fi

cd /tmp/kitty_yolo

# ------------------------------------------------------------------------------
# STEP 2: Clone Forked Source Code
# ------------------------------------------------------------------------------
log_info "Cloning your Kitty fork into memory..."
if [ -d "kitty" ]; then
    log_warn "Kitty directory already exists in RAM disk. Cleaning up..."
    rm -rf kitty
fi
git clone --depth 1 https://github.com/aDNAn-itis/kitty.git
cd kitty

# ------------------------------------------------------------------------------
# STEP 3: Install TRUE Build Dependencies
# ------------------------------------------------------------------------------
log_info "Adding modern Go compiler repository..."
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update

log_info "Installing core libraries, Wayland protocols, and docs extensions..."
sudo apt install -y python3-dev libdbus-1-dev libxcursor-dev libxrandr-dev \
    libxi-dev libxinerama-dev libgl1-mesa-dev libfontconfig1-dev \
    libharfbuzz-dev libpng-dev liblcms2-dev libssl-dev libxxhash-dev \
    libcanberra-dev libxkbcommon-x11-dev libwayland-dev golang-go \
    libcairo2-dev libx11-xcb-dev libx11-dev wayland-protocols libsimde-dev \
    fontconfig fonts-ubuntu fonts-dejavu-core fonts-firacode fonts-hack-ttf \
    python3-sphinx python3-sphinx-copybutton python3-sphinx-inline-tabs

log_info "Satisfying hidden Python docs requirements..."
python3 -m pip install --user --break-system-packages -r docs/requirements.txt

# ------------------------------------------------------------------------------
# STEP 4: Install Required Nerd Font
# ------------------------------------------------------------------------------
log_info "Baking Symbols Nerd Font into system..."
sudo mkdir -p /usr/share/fonts/truetype/nerdfonts
sudo curl -L -o /usr/share/fonts/truetype/nerdfonts/SymbolsNerdFontMono-Regular.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf
sudo fc-cache -f -v

# ------------------------------------------------------------------------------
# STEP 5: Compile the Binary
# ------------------------------------------------------------------------------
log_info "Building package natively via 'make linux-package'..."
make linux-package

# ------------------------------------------------------------------------------
# STEP 6: Deployment & Environment Configuration
# ------------------------------------------------------------------------------
log_info "Creating clean deployment environment..."
mkdir -p ~/.local/kitty-app
mkdir -p ~/.local/bin

log_info "Migrating compiled binary assets to permanent local directory..."
cp -r linux-package/* ~/.local/kitty-app/

log_info "Creating absolute symlink pointing to local binaries..."
ln -sf ~/.local/kitty-app/bin/kitty ~/.local/bin/kitty

log_info "Stripping symbols from the final binary to save space (~40MB)..."
strip ~/.local/kitty-app/bin/kitty

# ------------------------------------------------------------------------------
# STEP 7: Path Verification & Cleanup
# ------------------------------------------------------------------------------
log_info "Unmounting RAM disk and releasing memory allocations..."
cd /tmp
sudo umount /tmp/kitty_yolo || log_warn "Could not unmount /tmp/kitty_yolo automatically. It will clear on reboot."
sudo rm -rf /tmp/kitty_yolo

echo "------------------------------------------------------------------------------"
# Check if local bin path is configured in user environment shell profile
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    log_warn "Your ~/.local/bin path is missing from your global PATH environment variable."
    echo "To finalize configuration, append the following line to your ~/.bashrc or ~/.zshrc file:"
    echo -e "${GREEN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
fi

log_success "Kitty Terminal execution configuration completed cleanly!"
echo "Run 'source ~/.bashrc' or restart your terminal instance, then execute: kitty"
echo "=============================================================================="

```