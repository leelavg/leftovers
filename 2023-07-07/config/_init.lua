-- Filename:   config/init.lua
-- Github:     https://github.com/leelavg/dotfiles/

-- Incomplete, giving up to use init.vim itself

-- Globals {{{

vf = vim.fn
vc = vim.cmd
vo = vim.opt

-- }}}

-- Custom functions {{{

-- Install 'paq' plugin manager
local function installPaq()
    local paq = vim.fn.stdpath('data')..'/site/pack/paqs/opt/paq-nvim'
    if not vf.isdirectory(paq) then
        vf.mkdir(paq, 'p')
        vf.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq})
    end
end

-- Install plugins
local function plugins()

    require 'paq' {
        {'savq/paq-nvim', opt=true};
        'tpope/vim-surround';
        'tpope/vim-repeat';
        'jiangmiao/auto-pairs';
        'unblevable/quick-scope';
        'tpope/vim-commentary';
        'christoomey/vim-tmux-navigator';
        'junegunn/fzf.vim';
        'numirias/semshi';
        'mgedmin/python-imports.vim';
        'fatih/vim-go';
        'tpope/vim-fugitive';
        'prettier/vim-prettier';
        'srcery-colors/srcery-vim';
        'itspriddle/vim-shellcheck';
        'preservim/tagbar';
        'ludovicchabant/vim-gutentags';
        'hashivim/vim-terraform';
        'fatih/vim-hclfmt';
        'ncm2/float-preview.nvim';
        'lukas-reineke/indent-blankline.nvim'
        'ziglang/zig.vim';
        'fladson/vim-kitty';
        'mhinz/vim-signify';
        'jlcrochet/vim-crystal';

        -- LSP Stuff
        'neovim/nvim-lspconfig';
        'williamboman/mason-lspconfig.nvim';
        'williamboman/mason.nvim';
        {'ms-jpq/coq_nvim', branch='coq'};
    }
end

-- Load plugin manager on demand and install plugins
local function paq()

    local status, _ = pcall(require, 'paq')
    if not status then
        -- Install paq
        installPaq()
    end

    -- Init paq
    vc 'packadd paq-nvim'

    -- Install plugins
    plugins()

end

-- Show colors
local function synGroup()
    local sid = vf.synID(vf.line('.'), vf.col('.'), 1)
    print(vf.synIDattr(sid, 'name') .. ' -> ' .. vf.synIDattr(vf.synIDtrans(sid), 'name'))
end

-- Auto change dir to the root of file in the current window
-- https://inlehmansterms.net/2014/09/04/sane-vim-working-directories/
local function changeDir()
    local currentFile = vf.expand('%:p')
    if vf.getftype(currentFile) == 'link' then
        local actualFile = vf.resolve(currentFile)
        vc('file '..actualFile)
    end
    vf.lcd('%:p:h')
    local gitDir = vf.system('git rev-parse --show-toplevel')
    local isNotGitDir = vf.matchstr(gitDir, '^fatal:.*')
    if vf.empty(isNotGitDir) then
        vf.lcd(gitDir)
    end
end

-- }}}

-- Set commands {{{

vo.showmatch = true
vo.ignorecase = true
vo.hlsearch = true
vo.number = true
vo.relativenumber = true
vo.wildmenu = true
vo.wildmode= {'longest:full', 'full'}
vo.modelines=0
vo.nomodeline=true
vo.wrap=true
vo.scrolloff=100
vo.backspace={'indent','eol','start'}
vo.laststatus=2
vo.showcmd=true
vo.matchpairs:append('<:>')
vo.list=true
vo.encoding='utf-8'
vo.incsearch=true
vo.smartcase=true
vo.shada="'100,<9999,s100"
vo.formatoptions:append({'t','c','q','r','n','1'})
vo.shiftround=true
vo.lcs={tab='┊┈', lead='┈', eol='↴', nbsp='!', precedes='<', extends='>'}
vo.inccommand='split'
vo.smartindent=true
vo.foldmethod='marker'
vo.smarttab=true
vo.hidden=true
vo.fileformat='unix'
vo.tabstop=4
vo.softtabstop=4
vo.shiftwidth=4
vo.expandtab=true
vo.mouse='a'
vo.splitright=true
vo.splitbelow=true
vo.completeopt={'menu','menuone','noselect'}
vo.clipboard:append('unnamedplus')

-- }}}

-- Misc {{{

vc 'filetype plugin indent on'
vc 'syntax on'

-- }}}

local utils = { }

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

function utils.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

function utils.map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local cmd = vim.cmd
local indent = 4

cmd 'syntax enable'
cmd 'filetype plugin indent on'
utils.opt('b', 'expandtab', true)
utils.opt('b', 'shiftwidth', indent)
utils.opt('b', 'smartindent', true)
utils.opt('b', 'tabstop', indent)
utils.opt('o', 'hidden', true)
utils.opt('o', 'ignorecase', true)
utils.opt('o', 'scrolloff', 4 )
utils.opt('o', 'shiftround', true)
utils.opt('o', 'smartcase', true)
utils.opt('o', 'splitbelow', true)
utils.opt('o', 'splitright', true)
utils.opt('o', 'wildmode', 'list:longest')
utils.opt('w', 'number', true)
utils.opt('w', 'relativenumber', true)
utils.opt('o', 'clipboard','unnamed,unnamedplus')

-- Highlight on yank
vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

-- Map leader to space
vim.g.mapleader = ' '
local fn = vim.fn
local execute = vim.api.nvim_command

utils.map('n', '<C-l>', '<cmd>noh<CR>') -- Clear highlights
utils.map('i', 'jk', '<Esc>')           -- jk to escape

-- Auto install packer.nvim if not exists
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua
