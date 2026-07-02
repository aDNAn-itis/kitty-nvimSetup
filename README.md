# KittyBrain (Kitty-Neovim AI Context Vault)

A lightweight IPC bridge that fuses Neovim and the Kitty terminal to create a Project-Aware Second Brain for your terminal AI chats (Antigravity CLI, Codex, Claude Code, etc.).

## Keymaps
- `<leader>ai` : Sync File: Sends the contents of your current Neovim buffer to the AI pane.
- `<leader>as` : Archive Session: Saves the current AI chat to `~/.brain/archives/<Project_Name>/`.
- `:BrainRoam` : Browse Vault: Opens Neovim's file explorer to read through past saved conversations.
- `:BrainSearch <query>` : Search Memory: Compiles past chat contexts related to your query.
- `<leader>ac` : Inject Context: Sends your compiled memory directly into the AI pane.
