#!/bin/bash
# Waybar 模块: 应用运行中时显示图标, 否则隐藏
# 用法: app-icon.sh <qq|wechat>
# 图标: QQ=🐧 (U+1F427), 微信=💬 (U+1F4AC)
app="$1"
case "$app" in
    qq)     proc="qq";     icon="$(printf '\U0001F427')"; title="QQ" ;;
    wechat) proc="wechat"; icon="$(printf '\U0001F4AC')"; title="微信" ;;
    *)
        printf '{"text":""}\n'
        exit 0
        ;;
esac

if pgrep -x "$proc" >/dev/null 2>&1; then
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$icon" "$title" "$app"
else
    printf '{"text":""}\n'
fi
