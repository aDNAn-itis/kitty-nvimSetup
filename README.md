# KittyBrain (Kitty-Neovim AI Context Vault)

A lightweight IPC bridge that fuses Neovim and the Kitty terminal to create a Project-Aware Second Brain for your AI chats (Gemini, ChatGPT, Claude, etc.).

Are you tired of your AI losing context in long conversations? Do you want to save brilliant AI brainstorming sessions and instantly inject them into future chats? KittyBrain solves this.

## Features

- Instant Context Sync: Send your current Neovim file directly to a side-by-side Kitty AI pane with a single keystroke.
- Permanent Memory Vault: Archive your AI chats to local Markdown files.
- Project-Isolated Context: Archiving and searching are automatically isolated based on your current Neovim working directory. Your specific research won't mix with your web development code.
- Context Re-Injection: Search your past archives for specific topics and instantly inject that compiled memory back into a fresh AI session.

## Installation

### Prerequisites
- [Kitty Terminal](https://sw.kovidgoyal.net/kitty/)
- [Neovim](https://neovim.io/)
- `ripgrep` (for context searching)

### Setup
1. Clone this repository:
   ```bash
   git clone https://github.com/aDNAn-itis/kitty-nvimSetup.git
   ```
2. Run the bridge installer:
   ```bash
   cd kitty-nvimSetup
   ./setup_ai_bridge.sh
   ```
3. Restart Kitty so the new IPC socket (`/tmp/kitty_socket`) activates.

## Usage

Open a split pane in Kitty and load your favorite AI chat in the right pane.

Then, use these commands inside Neovim:

| Command | Action |
| :--- | :--- |
| `<leader>ai` | Sync File: Sends the contents of your current Neovim buffer to the AI pane. |
| `<leader>as` | Archive Session: Saves the current AI chat to `~/.brain/archives/<Project_Name>/`. |
| `:BrainSearch <query>` | Search Memory: Compiles past chat contexts related to your query. |
| `<leader>ac` | Inject Context: Sends your compiled memory directly into the AI pane. |

## Architecture

- Bash Scripts: Handles Kitty remote control commands (`get-text`, `send-text`), ANSI cleanup, and Ripgrep context building.
- Neovim Lua: Dynamically grabs your project paths and executes the bash scripts asynchronously so your editor never freezes.
