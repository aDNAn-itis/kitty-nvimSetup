-- ~/.config/nvim/lua/custom/brain.lua
local M = {}

function M.setup()
    local scripts_dir = vim.fn.expand("~/.brain/scripts")

    -- 1. Archive Session
    vim.keymap.set('n', '<leader>as', function()
        vim.notify("Archiving chat...", vim.log.levels.INFO)
        vim.fn.jobstart({"bash", scripts_dir .. "/archive_chat.sh"}, {
            on_exit = function(_, exit_code, _)
                if exit_code == 0 then
                    vim.notify("Chat successfully archived!", vim.log.levels.INFO)
                else
                    vim.notify("Failed to archive chat.", vim.log.levels.ERROR)
                end
            end
        })
    end, { desc = "Archive Kitty Chat Session" })

    -- 2. User Command :BrainSearch
    vim.api.nvim_create_user_command('BrainSearch', function(opts)
        local keyword = opts.args
        if keyword == "" then
            vim.notify("Please provide a search keyword.", vim.log.levels.WARN)
            return
        end

        vim.notify("Building context for: " .. keyword, vim.log.levels.INFO)
        vim.fn.jobstart({"bash", scripts_dir .. "/build_context.sh", keyword}, {
            on_exit = function(_, exit_code, _)
                if exit_code == 0 then
                    vim.notify("Context built successfully!", vim.log.levels.INFO)
                else
                    vim.notify("Failed to build context.", vim.log.levels.ERROR)
                end
            end
        })
    end, { nargs = 1, desc = "Search brain archives and compile context" })

    -- 3. Inject Context
    vim.keymap.set('n', '<leader>ac', function()
        -- Execute kitty send-text non-blockingly
        local cmd = {
            "kitty", "@", "--to", "unix:/tmp/kitty_socket",
            "send-text", "--match", "neighbor:right",
            "/read ~/.brain/active_context.md\r"
        }
        
        vim.fn.jobstart(cmd, {
            on_exit = function(_, exit_code, _)
                if exit_code == 0 then
                    vim.notify("Context injected into AI pane!", vim.log.levels.INFO)
                else
                    vim.notify("Failed to inject context.", vim.log.levels.ERROR)
                end
            end
        })
    end, { desc = "Inject Brain Context to AI Pane" })
end

return M
