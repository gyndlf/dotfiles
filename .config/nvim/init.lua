-- James' NeoVim configuration

-- save in vim.g.os the current os version
if vim.fn.exists('g:os') == 0 then
    local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
    if is_windows then
        vim.g.os = "Windows"
    else
        local uname_output = vim.fn.system('uname')
        vim.g.os = string.gsub(uname_output, '\n', '')
    end
end

vim.opt.number = true		-- show line numbers and relative numbers
vim.opt.hlsearch = true		-- highlight all results
vim.opt.ignorecase = true	-- ignore case in search
vim.opt.incsearch = true	-- show search results as you type
vim.opt.timeout = false
-- vim.opt.clipboard = "unnamed"	-- Link p and y to the system clipboard instead of "+p

vim.opt.spelllang = 'en_au'
vim.opt.spell = true

vim.cmd([[
filetype plugin indent on	" show existing tab with 4 spaces width
syntax enable
]])
vim.opt.tabstop = 4		-- when indenting with '>', use 4 spaces width
vim.opt.shiftwidth = 4		-- On pressing tab, insert 4 spaces
vim.opt.expandtab = true

-- Use a spell checker
-- ]s and [s to move between words, z= to get suggestions, zg to add to dictionary
vim.opt.spelllang = 'en_nz'
vim.opt.spell = true

vim.g.mapleader = " "	-- Set the leader keybind
vim.keymap.set('n', '<space>', '<NOP>', { desc = 'Space does nothing. (Except leader)' })
vim.g.maplocalleader = "," 

vim.keymap.set('n', '<leader><esc>', ':noh<return><esc>', { desc = 'Hit leader escape to stop highlighting from search' }) -- Conflicts with escaping telescope

-- Setup the internal terminal (mostly used by iron.nvim)
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { desc = 'Exit insert terminal mode' })
vim.keymap.set('n', '<leader>t', ':edit term://zsh', { desc = 'Start a terminal session' })

-- Install Lazy.nvim for plugin management. Bootstrap it to install itself
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Presetup color scheme before importing
-- Colorscheme (NeoSolarized.nvim)
local setupColors = function() 
    local ok_status, NeoSolarized = pcall(require, "NeoSolarized")
    if not ok_status then
        return
    end
    NeoSolarized.setup {
        style = "dark",
        transparent = false
    }
    vim.cmd [[ 
        try
            colorscheme NeoSolarized 
        catch 
            colorscheme default
            set background=dark
        endtry
    ]]
end

-- Configure plugins for installation
require("lazy").setup({
    {'jrzingel/NeoSolarized.nvim', lazy = false, priority = 1000, config = setupColors},
    'neovim/nvim-lspconfig',
    'nvim-lualine/lualine.nvim',
    'aserowy/tmux.nvim',
    {'nvim-treesitter/nvim-treesitter', build = ":TSUpdate" },
    {'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' }},
    'lervag/vimtex', -- Configure in tex.lua
    'Vigemus/iron.nvim',  -- Configure in each filetype
    'JuliaEditorSupport/julia-vim',
    'andymass/vim-matchup',
--    'L3MON4D3/LuaSnip',
    'anufrievroman/vim-angry-reviewer',  -- scientific document grammer suggestor
})

-- Specific plugin management

-- Status line (lualine.nvim)
require('lualine').setup {
    options = {
        theme = 'NeoSolarized'
    }
}

-- Tmux integration (tmux.nvim)
-- Make sure ~/.tmux.conf matches the default keybinds! Otherwise you can't quickly navigate back :(
-- Adds movements with <C-h> etc
require('tmux').setup {}

-- File searcher (telescope.nvim)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Search in file names" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Search in files (respecting .gitignore)" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Search in open buffers" })

-- Syntax highlighter (treesitter)
require('nvim-treesitter.configs').setup {
    ensure_installed = {"lua", "julia", "python"},
    highlight = {
        enable = true,
        disable = function(lang, buf)  -- disable highlighting for large files
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
            if lang == "latex" then  -- use vimtex for latex highlighting
                return true
            end
        end,
        additional_vim_regex_highlighting = { "latex" },
    },
    incremental_selection = {  -- add some new motions
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    matchup = {
        enable = true
    },
}

-- Language server (Code completion and insight)
local lspconfig = require('lspconfig')
lspconfig.arduino_language_server.setup { cmd = { "/Users/james/go/bin/arduino-language-server", "-cli-config", "sketch.yaml" }}

-- Remap keys to access diagnostic features
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- REPL integration (iron.nvim)
require('iron.core').setup {
    config = {
        repl_definition = {
            julia = {
                command = {"julia", "--proj=."}
            }
        },
        repl_open_cmd = require('iron.view').split.vertical.botright("40%"),
    },
    keymaps = {
        visual_send = "<leader>sv",
        send_file = "<leader>sf",
        cr = "<leader>s<cr>",
        interrupt = "<leader>s<space>",
        exit = "<leader>sq",
        clear = "<leader>sc",
    },
    highlight = {
        italic = true
    },
    ignore_blank_lines = true,
}

vim.keymap.set('n', '<leader>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<leader>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>')

-- Activate the snippets (mainly for latex)
-- Uses the "SnipMate-Like" method
--local ls = require("luasnip")
--vim.keymap.set({"i"}, "<Tab>", function() ls.expand() end, {silent = true})
--require("luasnip.loaders.from_snipmate").lazy_load({paths = "./snippets"})

-- Angry reviewer (grammer)
vim.g.AngryReviewerEnglish = 'british'
vim.keymap.set('n', '<leader>ar', ':AngryReviewer<CR>', {desc='Generate review recommendations'})
vim.keymap.set('n', ']c', ':cn<CR>', {desc='Next quick-fix error'})
vim.keymap.set('n', '[c', ':cp<CR>', {desc='Previous quick-fix error'})



