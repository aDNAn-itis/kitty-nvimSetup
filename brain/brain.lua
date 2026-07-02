-- ==============================================================================
-- SECOND BRAIN BRIDGE
-- ==============================================================================
local scripts_dir = vim.fn.expand("~/.brain/scripts")

-- <leader>as: Execute the archiver script.
vim.keymap.set('n', '<leader>as', function()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    vim.notify("Archiving chat for project: " .. project_name, vim.log.levels.INFO)
    vim.fn.jobstart({"bash", scripts_dir .. "/archive_chat.sh", project_name}, {
        on_exit = function(_, exit_code, _)
            if exit_code == 0 then vim.notify("Chat archived!", vim.log.levels.INFO) end
        end
    })
end, { desc = "Archive Kitty Chat" })

-- :BrainSearch <keyword>: Compile context based on the keyword.
vim.api.nvim_create_user_command('BrainSearch', function(opts)
    local keyword = opts.args
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    vim.notify("Building context for: " .. keyword, vim.log.levels.INFO)
    vim.fn.jobstart({"bash", scripts_dir .. "/build_context.sh", project_name, keyword}, {
        on_exit = function(_, exit_code, _)
            if exit_code == 0 then vim.notify("Context built!", vim.log.levels.INFO) end
        end
    })
end, { nargs = 1, desc = "Search brain archives" })

-- <leader>ac: Inject the compiled context file into the AI pane.
vim.keymap.set('n', '<leader>ac', function()
    local cmd = { "kitty", "@", "--to", "unix:/tmp/kitty_socket", "send-text", "--match", "neighbor:right", "/read ~/.brain/active_context.md\\r" }
    vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code, _)
            if exit_code == 0 then vim.notify("Context injected!", vim.log.levels.INFO) end
        end
    })
end, { desc = "Inject Brain Context" })
