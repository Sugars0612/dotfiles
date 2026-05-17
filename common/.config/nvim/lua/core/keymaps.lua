-- 主键 类似tmux的(Prefix)
vim.g.mapleader = " "

local keymap = vim.keymap

----- 插入模式 -----
keymap.set("i", "qi", "<ESC>")

-- 视觉模式
-- keymap.set("v", "J", ">+1<CR>gv=gv")


----- 正常模式 -----
-- 窗口
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>h")

-- 取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>")
