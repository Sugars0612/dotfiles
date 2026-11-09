#!/bin/bash
# Waybar custom/network 模块 —— 显示接口、IP、网关与协商速率
# 数据源: nmcli(状态/ESSID/信号/频率), ip(地址/网关), sysfs speed(协商速率)

ipaddr()    { ip -4 -o addr show "$1" 2>/dev/null | awk '{print $4}'; }
gwaddr()    { ip -4 route show default 2>/dev/null | awk '/via/{print $3; exit}'; }
linkspeed() { cat "/sys/class/net/$1/speed" 2>/dev/null; }
state()     { nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null; }

wiface=$(state | awk -F: '$2=="wifi" && $3=="connected"{print $1; exit}')
eface=$(state | awk -F: '$2=="ethernet" && $3=="connected"{print $1; exit}')

if [ -n "$wiface" ]; then
    info=$(nmcli -t -f IN-USE,SSID,SIGNAL,FREQ device wifi list --rescan no 2>/dev/null \
           | awk -F: '$1=="*"{print; exit}')
    essid=$(printf '%s' "$info" | cut -d: -f2)
    signal=$(printf '%s' "$info" | cut -d: -f3)
    freq_mhz=$(printf '%s' "$info" | cut -d: -f4 | grep -oE '[0-9]+')
    freq_ghz=$(awk -v m="${freq_mhz:-0}" 'BEGIN{printf "%.3f", m/1000}')
    ip=$(ipaddr "$wiface")
    gw=$(gwaddr)
    speed=$(linkspeed "$wiface")

    s=${signal:-0}
    if   [ "$s" -ge 80 ]; then icon="󰤨"
    elif [ "$s" -ge 60 ]; then icon="󰤥"
    elif [ "$s" -ge 40 ]; then icon="󰤢"
    else                        icon="󰤟"; fi

    tip="网络: ${essid}\nIP 地址: ${ip}\n网关: ${gw}\n信号强度: ${signal}%\n频率: ${freq_ghz} GHz"
    [ -n "$speed" ] && tip="${tip}\n协商速率: ${speed} Mb/s"

    printf '{"text":"%s","tooltip":"%s","class":"wifi","percentage":%s}\n' "$icon" "$tip" "$s"

elif [ -n "$eface" ]; then
    ip=$(ipaddr "$eface")
    gw=$(gwaddr)
    speed=$(linkspeed "$eface")

    tip="接口: ${eface}\nIP 地址: ${ip}\n网关: ${gw}"
    [ -n "$speed" ] && tip="${tip}\n协商速率: ${speed} Mb/s"

    printf '{"text":"󰈀","tooltip":"%s","class":"ethernet","percentage":100}\n' "$tip"

else
    if nmcli radio wifi 2>/dev/null | grep -qi 'disabled'; then
        printf '{"text":"󰤮","tooltip":"Wi-Fi 已关闭","class":"disabled","percentage":0}\n'
    else
        printf '{"text":"󰤯","tooltip":"网络已断开","class":"disconnected","percentage":0}\n'
    fi
fi
