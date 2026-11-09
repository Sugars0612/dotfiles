# Sugar Dotfiles

有关我的Dotfiles的配置文件仓库

## 安装

### Termux
```shell
git clone https://github.com/Sugars0612/dotfiles
cd dotfiles
chmod +x ./bootstrap-termux.sh ./install-termux.sh
./bootstrap-termux.sh && ./install-termux.sh
```

## 内容

- Termux 配置
  - 字体/主题配色
  - Shell: fish

- Arch Linux 桌面配置
  - 登录Shell: zsh (使用[zimfw](https://github.com/zimfw/zimfw)管理插件)
  - 终端模拟器: Kitty
  - 剪切板: [cliphist-tui](https://github.com/SHORiN-KiWATA/cliphist-tui)
  - 窗口管理器: niri
  - 输入法: fcitx5
  - 通知管理: mako
  - 状态栏: waybar
  - 锁屏: swaylock
  - 应用启动器: fuzzel
  - 截图标注: satty

- Arch Linux 软件配置
  - 终端复用器: tmux (使用[tpm](https://github.com/tmux-plugins/tpm)管理插件)
  - 文本编辑器: neovim (使用[lazy.nvim](https://github.com/folke/lazy.nvim)管理插件) 
  - 系统信息展示器: fastfetch
  - 系统资源监视器: btop
  - 终端文件管理器: yazi
  - 虚拟机管理: QEMU + libvirt
  - 命令行模糊查找器: fzf
  - 录屏: OBS Studio（flatpak）
  - 局域网传输文件: LocalSend