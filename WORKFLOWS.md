# KittyBrain Workflows & Usage Guide

This document serves as a master reference for all the workflows, scripts, and keymaps integrated into the KittyBrain (setup++) ecosystem. Add new workflows to this file as they are created.

---

## 1. The Core AI Bridge (Terminal & Neovim)
KittyBrain uses Kitty terminal's remote control sockets to allow Neovim to send files and context directly into your AI chat pane (like Gemini or Antigravity).

**How to Use:**
1. Open Kitty and split the pane (`Ctrl+Alt+c`). Keep your AI chat running in the right pane.
2. In Neovim (left pane), use the following keymaps:
   * `<leader>ai` (Sync File): Automatically saves your current file and pushes its contents to the AI pane.
   * `<leader>as` (Archive Session): Saves your current AI conversation into `~/.brain/archives/<project_name>/chat_<timestamp>.md`.
   * `:BrainSearch <query>` (Search Memory): Uses Ripgrep to search through all past chats in the archive and compile a summary context file.
   * `<leader>ac` (Inject Context): Sends the compiled memory from `:BrainSearch` directly into the AI pane.
   * `:BrainRoam` (Browse Vault): Opens Neovim's file explorer in your `~/.brain/archives/` so you can manually read past conversations.

---

## 2. Gemini Web Vault Import (Umbrella Wrapper)
If you do deep research in the Gemini Web UI (browser) and want to sync that context back into your KittyBrain local vault, use the `brain-sync` workflow. 

This workflow uses the **"Umbrella Wrapper"** architecture: it stores your isolated research sessions neatly inside a single `project.md` file using `<sub-file>` tags. This tricks the AI into instantly reading the entire project context at startup, while keeping your research logically separated so you can easily edit it.

**How to Use:**
1. In your browser, use your custom Bookmarklet/JS script to download your Gemini conversation (it will save as `gemini_vault_archive_<date>.md` in `~/Downloads`).
2. Open your terminal in your project directory and run:
   ```bash
   ~/.brain/scripts/import_web_vault.sh
   # (Or simply run 'brain-sync' if you added the alias)
   ```
3. The script will find the file and ask you for an option:
   * **[U]pdate**: Automatically wraps the downloaded file in `<sub-file>` tags and appends it to your current directory's `project.md`. 
   * **[N]ew**: Prompts you for a new project name, creates a new workspace folder in `~/Projects/`, and initializes it with a `project.md` containing your web research.

*Note: Your AI assistant is strictly instructed by its global KittyBrain rules to respect the `<sub-file>` boundaries inside `project.md` and treat them as isolated contexts.*

---

*(Add new workflows below this line as the KittyBrain system evolves!)*
