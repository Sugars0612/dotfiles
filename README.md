# Sugar Dotfiles

有关我的Dotfiles的配置文件仓库

## 安装
可以通过`stow`符号管理器来安装对应内容 也可以使用安装脚本

### Termux
```shell
git clone https://github.com/Sugars0612/dotfiles
cd dotfiles
chmod +x ./bootstarp-termux.sh ./install-termux.sh
./bootstarp-termux.sh && ./install-termux.sh
```

## 内容
- Linux 配置
  - 登录Shell: zsh (使用[zimfw](https://github.com/zimfw/zimfw)管理插件)
  - 窗口管理器: niri (基本是[shorin-niri](https://github.com/SHORiN-KiWATA/shorin-niri)改了一下 就不上传了 可以看看他的项目)
  - 终端模拟器: Kitty (同上)
  - 输入法: fcitx5 (同上)
    
- Termux 配置
  - 字体/主题配色
  - Shell: fish

- Common 配置
  - 终端复用器: tmux (使用[tpm](https://github.com/tmux-plugins/tpm)管理插件)

## 使用的软件
  ### GUI
  - 窗口管理器: niri
  - 终端模拟器: Kitty
  - 输入法: fcitx5
  - 录屏: OBS Studio (flatpak)
  - 局域网传输文件: Localsend
  
  ### TUI
  - 终端复用器: tmux
  - 命令行模糊查找器: fzf
  - 终端文件管理器: yazi
  - 文本编辑器: neovim
  - 系统资源监视器: btop
