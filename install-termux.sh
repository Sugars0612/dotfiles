#!/bin/bash
dotfiles_path="${HOME}/dotfiles"
target_path="${HOME}"
# 字体
font_name="JetBrainsMonoNerdFont-Regular.ttf"

stow -d "$dotfiles_path" -t "$target_path" termux
ln -s "$HOME/.local/share/fonts/$font_name" "$HOME/.termux/font.ttf"

# 进入环境
clear
termux-reload-settings
fish