-- ==============================================================================
--  SINGLE FILE SETUP
-- ==============================================================================
-- Theme: High-Contrast Ghost (Lain / Wired Aesthetic)
-- ==============================================================================

-- ==========================================
-- MY PERSONAL DASHBOARD & UI PLUGINS
-- ==========================================

-- 1. Kanagawa Theme
vim.pack.add { 'https://github.com/rebelot/kanagawa.nvim' }
require("kanagawa").setup({
  compile = false,
  undercurl = true,
  transparent = true,
  theme = "dragon",
})
vim.cmd("colorscheme kanagawa")

-- 2. True Transparency Patch
vim.pack.add { 'https://github.com/xiyaowong/transparent.nvim' }
require("transparent").setup({
  extra_groups = {
    "BufferLineBackground", "BufferLineFill", "NeoTreeNormal", "NeoTreeNormalNC",
    "TelescopeNormal", "TelescopeBorder", "TelescopePromptBorder",
    "WhichKeyFloat", "NormalFloat", "FloatBorder",
  },
})
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("TransparentEnable")
  end
})

-- 3. The "Ghost Bar" Lualine
vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }
local colors = { ghost_bg = "#1e1e1e", ghost_fg = "#7a7a7a" }
local lain_theme = {
  normal   = { a = { bg = colors.ghost_bg, fg = colors.ghost_fg }, b = { bg = colors.ghost_bg, fg = colors.ghost_fg }, c = { bg = colors.ghost_bg, fg = colors.ghost_fg } },
  insert   = { a = { bg = colors.ghost_bg, fg = colors.ghost_fg } },
  visual   = { a = { bg = colors.ghost_bg, fg = colors.ghost_fg } },
  replace  = { a = { bg = colors.ghost_bg, fg = colors.ghost_fg } },
  command  = { a = { bg = colors.ghost_bg, fg = colors.ghost_fg } },
  inactive = { a = { bg = colors.ghost_bg, fg = colors.ghost_fg }, b = { bg = colors.ghost_bg, fg = colors.ghost_fg }, c = { bg = colors.ghost_bg, fg = colors.ghost_fg } }
}

require('lualine').setup({
  options = {
    theme = lain_theme,
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" }
  }
})