
" ================================================================================================
" 🐧🐧🐧 Basic settings 🐧🐧🐧
" ================================================================================================

"设置在光标距离窗口顶部或底部一定行数时，开始滚动屏幕内容的行为
set scrolloff=10

"--递增搜索功能：在执行搜索（使用 / 或 ? 命令）时，
"Vim 会在您输入搜索模式的过程中逐步匹配并高亮显示匹配的文本。
set incsearch

"--在搜索时忽略大小写
set ignorecase

"--将搜索匹配的文本高亮显示
set hlsearch

"--设置相对行号 和 当前行的绝对行号
set number relativenumber

"--将 Vim 的寄存器与系统剪贴板共享(win)
set clipboard=unnamed
"--将 Vim 的寄存器与系统剪贴板共享(Linux)
"set clipboard=unnamedplus

" ================================================================================================
" 🌍🌍🌍 No Leader Keymaps 🌍🌍🌍
" ================================================================================================
"--普通模式下使用回车键，向下/向上 增加一行
nmap <CR> o<Esc>
nmap <S-Enter> O<Esc>

"--在普通和插入模式下，向下交换行/向上交换行
nnoremap <C-j> :m +1<CR>
nnoremap <C-k> :m -2<CR>
inoremap <C-j> <Esc> :m +1<CR>gi
inoremap <C-k> <Esc> :m -2<CR>gi
xnoremap <C-j> :m '>+1<cr>gv=gv
xnoremap <C-k> :m '<-2<cr>gv=gv

"--将shift+j/k映射为向下/向上跳转5行
nnoremap J 5j
nnoremap K 5k

"--将 jj 和 jk 映射为 <Esc>
"jj和jk为主流配置，可按喜好自行调整
imap jj <Esc>
imap jk <Esc>

