#!/usr/bin/env bash

# ==============================================================================
# KITTY <-> NEOVIM  BRIDGE SCRIPT
# ==============================================================================
# Description: Enables Kitty remote control and injects a custom Neovim keymap
#              (<leader>ai) to automatically push file context to the llm pane.
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

clear
echo -e "${GREEN}"
echo "  ____       _     _             "
echo " | __ ) _ __(_) __| | __ _  ___  "
echo " |  _ \| '__| |/ _\` |/ _\` |/ _ \ "
echo " | |_) | |  | | (_| | (_| |  __/ "
echo " |____/|_|  |_|\__,_|\__, |\___| "
echo "                     |___/       "
echo -e "${NC}"
echo "=============================================================================="

# ------------------------------------------------------------------------------
# STEP 1: Enable Kitty Remote Control & Sockets
# ------------------------------------------------------------------------------
log_info "Configuring Kitty for remote IPC socket listening..."

if grep -q "listen_on unix:/tmp/kitty_socket" ~/.config/kitty/kitty.conf; then
    echo -e "${YELLOW}[SKIP]${NC} Kitty remote control is already configured."
else
    cat << 'EOF' >> ~/.config/kitty/kitty.conf

# --- NEOVIM IPC BRIDGE ---
# Allow Neovim to send commands to Kitty panes
allow_remote_control yes
listen_on unix:/tmp/kitty_socket
EOF
    log_success "Kitty remote control socket activated."
fi

# ------------------------------------------------------------------------------
# STEP 2: Inject Neovim Keymap to Send Context
# ------------------------------------------------------------------------------
log_info "Injecting Neovim Lua keymap for instant AI context syncing..."
mkdir -p ~/.config/nvim/lua/config

if [ -f ~/.config/nvim/lua/config/keymaps.lua ] && grep -q "KITTY -> GEMINI BRIDGE" ~/.config/nvim/lua/config/keymaps.lua; then
    echo -e "${YELLOW}[SKIP]${NC} Neovim keymap already exists."
else
    cat << 'EOF' >> ~/.config/nvim/lua/config/keymaps.lua

-- ==============================================================================
-- KITTY -> GEMINI BRIDGE
-- Saves the file and forces the right pane to ingest the updated code.
-- ==============================================================================
vim.keymap.set("n", "<leader>ai", function()
  -- 1. Save the current file first so the AI reads the latest version
  vim.cmd("w")
  
  -- 2. Get the exact relative path of the file you are looking at
  local filepath = vim.fn.expand("%")
  
  -- 3. Construct the Kitty remote command
  -- --to specifies the socket, --match neighbor:right targets your Gemini pane
  local kitty_cmd = string.format(
    'kitty @ --to unix:/tmp/kitty_socket send-text --match neighbor:right "/read %s\\r"',
    filepath
  )
  
  -- 4. Execute silently in the background
  os.execute(kitty_cmd)
  
  -- 5. Show a brief confirmation in Neovim
  vim.notify("Context synced to Gemini: " .. filepath, vim.log.levels.INFO)
end, { desc = "Sync current file to AI Right Pane" })
EOF
    log_success "Neovim <leader>ai keymap successfully injected."
fi

# ------------------------------------------------------------------------------
# STEP 3: Second Brain Context Vault Setup
# ------------------------------------------------------------------------------
# Set up the Second Brain Context Vault.
# Creates a permanent memory bank for AI chats.
log_info "Setting up Second Brain Context Vault..."

# Create storage directories in the home folder.
mkdir -p ~/.brain/scripts
mkdir -p ~/.brain/archives

# --- 1. The Archiver & Context Scripts ---
# Copy the Second Brain scripts into the user's home directory.
cp ./brain/archive_chat.sh ~/.brain/scripts/
cp ./brain/build_context.sh ~/.brain/scripts/
cp ./brain/import_web_vault.sh ~/.brain/scripts/

# Apply execution permissions to scripts.
chmod +x ~/.brain/scripts/archive_chat.sh ~/.brain/scripts/build_context.sh ~/.brain/scripts/import_web_vault.sh
log_success "Created the memory scripts in ~/.brain/scripts"

# --- 2. The Neovim Keymaps ---
# Inject Second Brain keybindings into Neovim configuration.
log_info "Adding Second Brain keybindings to Neovim..."
if [ -f ~/.config/nvim/lua/config/keymaps.lua ] && grep -q "SECOND BRAIN BRIDGE" ~/.config/nvim/lua/config/keymaps.lua; then
    echo -e "${YELLOW}[SKIP]${NC} Second Brain keymaps already exist."
else
    cat ./brain/brain.lua >> ~/.config/nvim/lua/config/keymaps.lua
    log_success "Second Brain Neovim keymaps injected."
fi

# ------------------------------------------------------------------------------
# STEP 4: Final Instructions
# ------------------------------------------------------------------------------
echo "------------------------------------------------------------------------------"
log_success "The AI Bridge & Second Brain Vault are fully operational!"
echo "To activate:"
echo "1. Completely close Kitty and reopen it (to spawn the new socket)."
echo "2. Press Ctrl+Alt+c to open your Gemini split pane."
echo "3. Neovim: [Space] + a + i (Sync current file to AI)"
echo "4. Neovim: [Space] + a + s (Archive AI chat to ~/.brain)"
echo "5. Neovim: :BrainSearch <keyword> (Compile past context)"
echo "6. Neovim: [Space] + a + c (Inject compiled context to AI)"
echo "=============================================================================="