#!/bin/bash
set -e

clear
echo "  _   _                 _           "
echo " | \ | | ___  _____   _(_)_ __ ___  "
echo " |  \| |/ _ \/ _ \ \ / / | '_ \` _ \ "
echo " | |\  |  __/ (_) \ V /| | | | | | |"
echo " |_| \_|\___|\___/ \_/ |_|_| |_| |_|"
echo "=============================================================================="

echo "[INFO] Installing system dependencies and Wayland clipboard..."
sudo apt update
sudo apt install -y ripgrep fd-find build-essential wl-clipboard

# --- THE RAM-BACKED DEPLOYMENT ---
echo "[INFO] Using RAM-backed /tmp directory for the download..."
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz

echo "[INFO] Moving ONLY the application to your SSD..."
mkdir -p "$HOME/.local"
rm -rf "$HOME/.local/nvim-app" 
mv nvim-linux-x86_64 "$HOME/.local/nvim-app"

echo "[INFO] Creating symlink and wiping memory..."
mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/.local/nvim-app/bin/nvim" "$HOME/.local/bin/nvim"
rm -rf /tmp/nvim-linux*

# --- THE CLEAN SLATE ---
echo "[INFO] Backing up old config and nuking Neovim cache/state files..."
if [ -d "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%s)"
fi
rm -rf "$HOME/.local/share/nvim"
rm -rf "$HOME/.local/state/nvim"
rm -rf "$HOME/.cache/nvim"

echo "[INFO] Cloning Kickstart base engine..."
git clone https://github.com/nvim-lua/kickstart.nvim.git "$HOME/.config/nvim"

echo "[INFO] Unlocking the custom dashboard in the new vim.pack engine..."
sed -i "s/-- require 'custom.plugins'/require 'custom.plugins'/g" "$HOME/.config/nvim/init.lua"

echo "[INFO] Applying HDD optimizations to init.lua..."
cat << 'EOF' >> "$HOME/.config/nvim/init.lua"

-- ==========================================
-- CUSTOM HARDWARE & PERFORMANCE TWEAKS
-- ==========================================
vim.opt.swapfile = false
vim.opt.undolevels = 1000
EOF

echo "[INFO] Preparing your personal dashboard folder..."
mkdir -p "$HOME/.config/nvim/lua/custom/plugins"

echo "[INFO] Ensuring ~/.local/bin is in PATH..."
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "[WARN] PATH updated. Please run 'source ~/.bashrc' after this script finishes."
fi

echo "------------------------------------------------------------------------------"
echo "[SUCCESS] Base Engine Deployment Complete!"
echo "Next Step: Place your personal init.lua inside lua/custom/plugins/"
echo "=============================================================================="