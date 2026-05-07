# 环境变量配置
rootfs=$PREFIX

# 更换镜像源
# cp "${rootfs}/etc/apt/sources.list" "${rootfs}/etc/apt/sources.list.bak"
# echo "deb https://mirror.sjtu.edu.cn/termux/termux-main/ stable main" > "${rootfs}/etc/apt/sources.list"

# 更新本地软件包
apt update -y && apt upgrade -y
# 安装基础插件
apt install -y stow
# 安装Shell和提示符美化插件
apt install -y fish starship fastfetch
