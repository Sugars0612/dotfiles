#!/bin/bash
dotfiles_path="${HOME}/dotfiles"
target_path="${HOME}"


stow -d "$dotfiles_path" -t "$target_path" termux common



# 切换默认shell
chsh -s fish