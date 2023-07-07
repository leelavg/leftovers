" Filename:   config/init.vim
" Github:     https://github.com/leelavg/dotfiles/

" Custom Functions {{{

" Install minpac
function! InstallMinpac() abort

    if !isdirectory($HOME.'/.config/nvim/pack')
        if !exists('*minpac#init')
            " Install minpac
            call mkdir($HOME.'/.config/nvim/pack/minpac/opt/', 'p')
            :silent !cd $HOME/.config/nvim/pack/minpac/opt/ && git clone https://github.com/k-takata/minpac.git 2>/dev/null
        endif
    endif

endfunction

" List of all plugins
function! Plugins() abort
        call minpac#add('tpope/vim-surround')
        call minpac#add('tpope/vim-repeat')
        call minpac#add('jiangmiao/auto-pairs')
        call minpac#add('unblevable/quick-scope')
        call minpac#add('tpope/vim-commentary')
        call minpac#add('christoomey/vim-tmux-navigator')
        call minpac#add('junegunn/fzf.vim')
        call minpac#add('numirias/semshi')
        call minpac#add('mgedmin/python-imports.vim')
        call minpac#add('fatih/vim-go')
        call minpac#add('tpope/vim-fugitive')
        call minpac#add('prettier/vim-prettier')
        call minpac#add('gruvbox-community/gruvbox')
        call minpac#add('itspriddle/vim-shellcheck')
        call minpac#add('preservim/tagbar')
        call minpac#add('ludovicchabant/vim-gutentags')
        call minpac#add('hashivim/vim-terraform')
        call minpac#add('fatih/vim-hclfmt')
        call minpac#add('ncm2/float-preview.nvim')
        call minpac#add('lukas-reineke/indent-blankline.nvim')
        call minpac#add('ziglang/zig.vim')
        call minpac#add('fladson/vim-kitty')
        call minpac#add('mhinz/vim-signify')
        call minpac#add('jlcrochet/vim-crystal')

        " LSP Stuff
        call minpac#add('neovim/nvim-lspconfig')
        call minpac#add('williamboman/mason-lspconfig.nvim')
        call minpac#add('williamboman/mason.nvim')
        call minpac#add('ms-jpq/coq_nvim', {'branch': 'coq'})

      endfunction

" Load Plugin Manager (minpac) on demand
function! Pack() abort

    call InstallMinpac()

    " Init and add minpac first
    packadd minpac
    call minpac#init()
    call minpac#add('k-takata/minpac', {'type':'opt', 'branch':'devel'})

    " Install all plugins
    call Plugins()

endfunction

" Show colors
function! <SID>SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction

" Auto change dir to the root of file in the current window
" https://inlehmansterms.net/2014/09/04/sane-vim-working-directories/

function! ChangeDir()
  let current_file = expand('%:p')

  " do not change dir if we are using vim fugitive
  let is_fugitive = matchstr(current_file, '^fugitive')
  if len(is_fugitive) != 0
      return
  endif

  " check if file type is a symlink
  if getftype(current_file) == 'link'
    " if it is a symlink resolve to the actual file path and open the actual file
    let actual_file = resolve(current_file)
    silent! execute 'file ' . actual_file
  end
  " default to the current file's directory
  lcd %:p:h
  let git_dir = system("git rev-parse --show-toplevel")
  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project, change local directory to git project root
  if empty(is_not_git_dir)
    lcd `=git_dir`
  endif
endfunction

" }}}

" Set Commands {{{

set showmatch                               " show matching brackets.
set ignorecase                              " case insensitive matching
set hlsearch                                " highlight search results
set number                                  " add line numbers
set relativenumber                          " for easy movements
set wildmenu                                " Vim tab completions
set wildmode=longest:full,full              " Vim tab completions
set modelines=0                             " Turn off modelines
set nomodeline                              " Turn off modelines
set wrap                                    " Automatically wrap text that extends beyond the screen length.
set scrolloff=100                           " Display 100 lines above/below the cursor when scrolling with a mouse.
set backspace=indent,eol,start              " Fixes common backspace problems
set laststatus=2                            " Status bar
set showcmd                                 " Display options
set matchpairs+=<:>                         " Highlight matching pairs of brackets. Use the '%' character to jump between them.
set list                                    " Display different types of white spaces.
set encoding=utf-8                          " Encoding
set incsearch                               " Enable incremental search
set smartcase                               " Include only uppercase words with uppercase search term
set shada='100,<9999,s100                   " Store more info
set formatoptions+=tcqrn1                   " Control formats on newlines
set shiftround                              " Rounding to shiftwidth in block operations
set lcs=tab:┊┈,lead:┈,eol:↴         " lists character
set lcs+=nbsp:!,precedes:<,extends:>        " some more lists character
set inccommand=split                        " Searches in a split window
set smartindent                             " Context awareness
set foldmethod=marker                       " Fold on markers, currently used for config/* files
set smarttab
set hidden
set fileformat=unix
set tabstop=4                              " number of columns occupied by a tab character
set softtabstop=4                          " see multiple spaces as tabstops so <BS> does the right thing
set shiftwidth=4                           " width for autoindents
set expandtab                              " converts tabs to white space
set mouse=a                                " helps not scrolling tmux pane
set splitright                             " Always open new split (vsp) right side of current buffer
set splitbelow                             " Always open new split (sp) below current buffer
set completeopt=noinsert,menuone,noselect  " Completion menu while using omnifunc
set clipboard+=unnamedplus                 " Use providers (~tmux) clipboard capabilities

" }}}

" Misc {{{

filetype plugin indent on                   " allows auto-indenting depending on file type
syntax on                                   " syntax highlighting

" }}}

" All Mappings {{{

nmap               <space>   <leader>
noremap  <silent> <leader>n  :source $HOME/.init.vim<cr>
noremap  <silent> <leader>r  :set cursorline!<CR>
noremap  <silent> <leader>p  :set paste!<CR>
nnoremap <silent> <leader>=  :wincmd _<cr>:wincmd \|<cr>
nnoremap <silent> <leader>-  :wincmd =<cr>
nnoremap <silent> <F8>       :TagbarToggle<cr>
noremap  <silent> <leader>v  :vsp <cr>:exec("tag ".expand("<cword>"))<cr>
noremap  <silent> <leader>o  :only<cr>
nnoremap <silent> <leader>u  :set rnu! nu!<cr>

nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>F :GFiles<cr>
nnoremap <silent> <leader>l :Lines<cr>
nnoremap <silent> <leader>c :BCommits<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>m :Marks<cr>
nnoremap <silent> <leader>T :BTags<cr>
nnoremap <silent> <leader>t :Tags<cr>
nnoremap <silent> <leader>i :ImportName<cr>

" Ripgrep
nnoremap <leader>rg :Rg<space>
nnoremap <leader>rg! :Rg!<space>

" Lua bindings
nnoremap <silent> <leader>a :luafile %<cr>

" Prettier JS
nnoremap <leader>pr :PrettierAsync %<cr>

" Colors
" :so $VIMRUNTIME/syntax/hitest.vim
nnoremap <leader>s :call <SID>SynGroup()<cr>

" Easy for mode switch and multi-lines
nnoremap 0 ^
nnoremap j gj
nnoremap k gk
inoremap jk <esc>:w<cr>
inoremap kj <esc>:w<cr>
nnoremap <silent> <BS> :nohl<cr>

" Navigating suggestions
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
inoremap <expr> <tab>   pumvisible() ? "\<C-n>" : "\<tab>"

" Use jumplist in place of changelist
nnoremap <silent> g; <C-o>
nnoremap <silent> g, <C-i>

" ShellCheck in QuickFix window
nnoremap <silent> gb :ShellCheck! <cr>

" Format shell scripts
nnoremap <silent> sf :!shfmt -i 2 -ci -w % <cr>

" }}}

" Command Aliases {{{

command! Q q
command! Qall qall
command! QA qall
command! E e
command! X x
command! PackUpdate    call Pack()      | call minpac#update()
command! PackClean     call Pack()      | call minpac#clean()
command! PackStatus    packadd minpac   | call minpac#status()

" Remove tags cache dir
command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

" }}}

" Aesthetics{{{

highlight VertSplit     cterm=NONE

" QuickScope character highlights
highlight QuickScopePrimary     guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary   guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

set statusline=\|CWD:%r%{getcwd()}%h\|%=\|Path:%f\|%=\|Total:%L,Line:%l,Column:%c\|

" }}}

" Autocommands {{{

augroup AdhocSettings
    autocmd!

    " Rebalance windows on vim resize
    autocmd VimResized * :wincmd =

    " Escape inside a FZF terminal window should exit the terminal window
    autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>

    " Close quickfix/locationlist/help windows with with <esc>
    autocmd FileType qf nnoremap <silent> <buffer> <esc> :q<cr>
    autocmd Filetype help nnoremap <silent> <buffer> <esc> :q<CR>

    " Highlight Nomad files as plain HCL
    autocmd BufNewFile,BufRead *.nomad,*.vars set syntax=hcl

    " Start COQ after VimEnter event
    autocmd VimEnter * :COQnow -s

    " Autochange current working to window file root
    autocmd BufWinEnter * call ChangeDir()

    " Highlight yank
    autocmd TextYankPost * silent! lua vim.highlight.on_yank() {on_visual=false}

augroup END

" Highlight Window
augroup BgHighlight
    autocmd!
    autocmd WinEnter,BufEnter * set colorcolumn=80 cursorline
    autocmd WinLeave * set colorcolumn=0 nocursorline
augroup END

" Basic Settings for Python
augroup filetype_python
    autocmd!
    autocmd FileType python set textwidth=79  " Break text after reaching textwidth
    autocmd FileType python set autoindent    " indent a new line the same amount as the line just typed
    autocmd Filetype python set foldmethod=syntax foldnestmax=2 nofoldenable
augroup END

" Basic Setting for YAML and bash
augroup filetype_yaml
    autocmd!
    autocmd BufNewFile,BufRead *yaml* set filetype=yaml " If yaml is part of Jinja template
    autocmd FileType yaml,sh set ts=2 sts=2 sw=2 expandtab indentkeys-=0#
    autocmd FileType yaml set indentkeys-=<:> foldmethod=indent nofoldenable
augroup END

" For blogging
augroup filetype_md
  autocmd!
  autocmd FileType markdown,mkd setlocal spell wrap textwidth=79 complete+=kspell
  autocmd FileType text         setlocal spell wrap textwidth=79 complete+=kspell
  autocmd FileType adoc         setlocal spell wrap textwidth=79 complete+=kspell
augroup END

" Key bindings for golang
augroup filetype_go
    autocmd!
    autocmd FileType go nnoremap <buffer> <silent> <leader>go :GoRun<cr>
    autocmd FileType go nnoremap <buffer> <silent> <leader>gt :GoTest<cr>
    autocmd FileType go nnoremap <buffer> <silent> <leader>ga :GoAlternate<cr>
    autocmd Filetype go set foldmethod=syntax foldnestmax=2 nofoldenable
augroup END

" }}}

" Variable Modifications {{{

" FZF
let g:fzf_commits_log_options = '--graph --color=always
\ --format="%C(yellow)%h%C(red)%d%C(reset)
\ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }

" Quickscope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Gutentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_modules = ['ctags']
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_cache_dir = expand('~/.cache/ctags/')
let g:gutentags_plus_switch = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = [
    \ '--tag-relative=yes',
    \ '--fields=+ailmnS',
    \ ]
let g:gutentags_ctags_exclude = [
    \ '*.git', '*.svg', '*.hg', '*/tests/*', 'build', 'dist', '*sites/*/files/*',
    \ 'bin', 'node_modules', 'bower_components', 'cache', 'compiled', 'docs',
    \ 'example', 'bundle', 'vendor', '*.md', '*-lock.json', '*.lock',
    \ '*bundle*.js', '*build*.js', '.*rc*', '*.json', '*.min.*', '*.map',
    \ '*.bak', '*.zip', '*.pyc', '*.class', '*.sln', '*.Master', '*.csproj',
    \ '*.tmp', '*.csproj.user', '*.cache', '*.pdb', 'tags*', 'cscope.*',
    \ '*.css', '*.less', '*.scss', '*.exe', '*.dll', '*.mp3', '*.ogg',
    \ '*.flac', '*.swp', '*.swo', '*.bmp', '*.gif', '*.ico', '*.jpg',
    \ '*.png', '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz',
    \ '*.tar.bz2', '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
    \ ]

" vim-go
let g:go_fmt_command = 'goimports'
let g:go_highlight_format_strings = 1
let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1
let g:go_doc_popup_window = 1

" Colorscheme
set termguicolors
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark=1
colorscheme gruvbox

" Float Preview
let g:float_preview#docked = 0

" Support embed Lua
let g:vimsyn_embed = 'l'

" For autochange dir to work correctly
let g:netrw_keepdir=0

" }}}

" Config in Lua {{{

lua << EOF

-- COQ Settings
vim.g.coq_settings = {
    keymap = {
        jump_to_mark = '', -- Don't mess up tmux-navigator
    },
    display = {
        icons = {
            mode = 'none',
        },
    },
    clients = {
        tags = {
            enabled = true,
            short_name = 'T',
        },
        tree_sitter = {
            enabled = false,
        },
        buffers = {
            same_filetype = true,
            short_name = 'B',
        },
        tmux = {
            enabled = false,
        },
        tabnine = {
            enabled = false,
        },
        lsp = {
            short_name = 'L',
        },
        snippets = {
            -- Don't bother about snippets
            warn = {},
        },
    },
}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('i', '<A-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>g', vim.lsp.buf.formatting, bufopts)
end

-- LSP Servers Installation
local mason = require('mason').setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
local required = {'gopls', 'pyright', 'vimls', 'zls', 'crystalline'}
local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({
    ensure_installed = required
})
mason_lspconfig.setup_handlers({
    function(pkg)
        lspconfig[pkg].setup{
            on_attach=on_attach
        }
    end,
})

EOF

" }}}

" Notes {{{

" Registers:
"
" - unnamed or default register: "
"
" 4 read-only registers:
" - last inserted text is stored on ".
" - current file path in "% and 'let' is used to write to a register
" so :let @+=@% copies path to clipboard
" - most recenty executed command: ":
" - name of the alternate file: "#
"
" expression and search registers:
" - results of expressions, in insert mode, use with ctrl+r: "=
" - search register is at: <ctrl+r/>
"
" macros:
" - `qw` macro is recored in "w register
" - `:let @W='i;'` appends to `w` register
" - edit on fly, `:let @w='ctrl+r w>` change and close the quote
"
" }}}
