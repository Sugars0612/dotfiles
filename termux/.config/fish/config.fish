function fish_greeting
    fastfetch
end

set -g PATH $HOME/.local/bin $PATH
# Set up fzf key bindings
fzf --fish | source
starship init fish | source