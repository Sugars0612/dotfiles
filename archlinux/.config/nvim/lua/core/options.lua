local opt = vim.opt

-- 行号显示
opt.relativenumber = true
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- 关闭自动换行
opt.wrap = false

-- 高亮当前行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 剪切板
opt.clipboard:append("unnamedplus")

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
