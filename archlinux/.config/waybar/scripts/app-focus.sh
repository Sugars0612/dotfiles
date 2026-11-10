#!/bin/bash
# 聚焦(唤起)指定应用的窗口
# 用法: app-focus.sh <qq|wechat>
app="$1"
case "$app" in
    qq)     app_id="QQ";     main_title="QQ" ;;
    wechat) app_id="wechat"; main_title="微信" ;;
    *)      exit 0 ;;
esac

id=$(niri msg -j windows 2>/dev/null | python3 -c '
import sys, json
app_id = sys.argv[1]
main_title = sys.argv[2]
try:
    wins = json.load(sys.stdin)
except Exception:
    sys.exit(0)
cands = [w for w in wins if w.get("app_id") == app_id]
if not cands:
    sys.exit(0)
# 优先主窗口(标题匹配), 否则最近聚焦的窗口
target = None
for w in cands:
    if w.get("title") == main_title:
        target = w
        break
if target is None:
    target = max(cands, key=lambda w: (
        (w.get("focus_timestamp") or {}).get("secs", 0),
        (w.get("focus_timestamp") or {}).get("nanos", 0),
    ))
print(target.get("id", ""))
' "$app_id" "$main_title")

[ -n "$id" ] && niri msg action focus-window --id "$id"
