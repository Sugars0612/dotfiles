# Sugar Dotfiles

有关我的Dotfiles的配置文件仓库

## 内容
- Linux 配置
  - Shell: zsh (使用[Zimfw](https://zimfw.sh/)管理插件)
  - 终端复用器: tmux (使用[tpm](https://github.com/tmux-plugins/tpm)管理插件)
  
- Termux 配置
  - 字体/主题配色
  - Shell: fish

## 安装
你可以通过`stow`符号管理器来安装对应内容 也可以使用我的安装脚本

### Termux
```shell
git clone https://github.com/Sugars0612/dotfiles
cd dotfiles
chmod +x ./bootstarp-termux.sh ./imstall-termux.sh
./bootstarp-termux.sh
./install-termux.sh
```