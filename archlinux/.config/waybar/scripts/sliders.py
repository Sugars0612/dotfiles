#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Waybar 顶栏滑块 TUI —— 输出音量 / 麦克风 / 屏幕亮度

键盘:  ↑/↓ 或 j/k   切换选中项
       ←/→ 或 h/l   微调 ±2
       + / -        微调 ±2
       PgUp / PgDn  大步 ±10
       m            静音开关(音量项)
       q / Esc / Enter  退出
鼠标:  滚轮调整当前项；左键点击滑条直接跳到对应百分比
"""
import curses
import subprocess

SINK = "@DEFAULT_AUDIO_SINK@"
SOURCE = "@DEFAULT_AUDIO_SOURCE@"
STEP = 2
BIG_STEP = 10


def _run(cmd):
    try:
        return subprocess.run(cmd, capture_output=True, text=True).stdout.strip()
    except Exception:
        return ""


def clamp(v, lo, hi):
    return max(lo, min(hi, v))


# ---- 后端 ----
def get_volume(device):
    out = _run(["wpctl", "get-volume", device])
    muted = "MUTED" in out
    val = 0
    parts = out.split()
    if len(parts) >= 2:
        try:
            val = clamp(round(float(parts[1]) * 100), 0, 100)
        except ValueError:
            val = 0
    return val, muted


def set_volume(device, pct):
    _run(["wpctl", "set-volume", device, f"{clamp(pct, 0, 100) / 100.0:.2f}"])


def toggle_mute(device):
    _run(["wpctl", "set-mute", device, "toggle"])


def get_brightness():
    out = _run(["brightnessctl", "-m"])
    try:
        return clamp(int(out.split(",")[3].rstrip("%")), 0, 100), False
    except (IndexError, ValueError):
        return 0, False


def set_brightness(pct):
    _run(["brightnessctl", "set", f"{clamp(pct, 0, 100)}%"])


ITEMS = [
    {"label": "输出音量", "get": lambda: get_volume(SINK),
     "set": lambda v: set_volume(SINK, v),
     "mute": lambda: toggle_mute(SINK), "can_mute": True},
    {"label": "麦克风", "get": lambda: get_volume(SOURCE),
     "set": lambda v: set_volume(SOURCE, v),
     "mute": lambda: toggle_mute(SOURCE), "can_mute": True},
    {"label": "屏幕亮度", "get": get_brightness,
     "set": set_brightness, "mute": None, "can_mute": False},
]


def render_bar(pct, width):
    inner = width - 2
    if inner <= 0:
        return ""
    fill = int(round(pct * inner / 100.0))
    return "[" + "█" * fill + "░" * (inner - fill) + "]"


def _adjust(sel, delta):
    val, _ = ITEMS[sel]["get"]()
    ITEMS[sel]["set"](val + delta)


def draw(stdscr, sel, values):
    stdscr.erase()
    h, w = stdscr.getmaxyx()
    bar_width = clamp(w - 24, 10, 48)
    title = " 音量 / 亮度 "
    if h >= 1:
        try:
            stdscr.addstr(0, max(0, (w - len(title)) // 2), title, curses.A_REVERSE)
        except curses.error:
            pass
    top = 2
    bar_rows = []
    for i, item in enumerate(ITEMS):
        row = top + i
        if row >= h:
            break
        val, muted = values[i]
        attr = curses.A_REVERSE if i == sel else curses.A_NORMAL
        bar_start = 10
        try:
            stdscr.addstr(row, 2, f"{item['label']:<6}", attr)
            stdscr.addstr(row, bar_start, render_bar(val, bar_width), attr)
            stdscr.addstr(row, bar_start + bar_width + 1, f"{val:3d}%", attr)
        except curses.error:
            pass
        if item["can_mute"] and muted:
            try:
                stdscr.addstr(row, bar_start + bar_width + 6, "[静音]")
            except curses.error:
                pass
        bar_rows.append((i, row, bar_start, bar_start + bar_width))
    hint = " ↑↓选择  ←→/滚轮  m静音  q退出 "
    hint_row = top + len(ITEMS)
    if hint_row < h:
        try:
            stdscr.addstr(hint_row, 2, hint)
        except curses.error:
            pass
    stdscr.refresh()
    return bar_rows


def main(stdscr):
    curses.curs_set(0)
    curses.mouseinterval(0)
    try:
        curses.mousemask(curses.BUTTON1_PRESSED | curses.BUTTON1_CLICKED |
                         curses.BUTTON4_PRESSED | curses.BUTTON5_PRESSED)
    except curses.error:
        pass
    stdscr.keypad(True)
    sel = 0
    while True:
        values = [it["get"]() for it in ITEMS]
        bar_rows = draw(stdscr, sel, values)
        k = stdscr.getch()
        if k == -1:
            continue

        if k == curses.KEY_MOUSE:
            try:
                _, mx, my, _, bstate = curses.getmouse()
            except curses.error:
                continue
            if bstate & curses.BUTTON4_PRESSED:      # 滚轮上
                _adjust(sel, STEP)
                continue
            if bstate & curses.BUTTON5_PRESSED:      # 滚轮下
                _adjust(sel, -STEP)
                continue
            if bstate & (curses.BUTTON1_PRESSED | curses.BUTTON1_CLICKED):
                for (idx, row, bs, be) in bar_rows:
                    if row == my and bs < mx < be:
                        sel = idx
                        inner = be - bs - 2
                        pct = clamp(round((mx - bs - 1) * 100 / inner), 0, 100)
                        ITEMS[idx]["set"](pct)
                continue

        # 键盘
        if k in (ord("q"), ord("Q"), 27, 10, 13, curses.KEY_ENTER):
            break
        elif k in (curses.KEY_UP, ord("k")):
            sel = (sel - 1) % len(ITEMS)
        elif k in (curses.KEY_DOWN, ord("j")):
            sel = (sel + 1) % len(ITEMS)
        elif k in (curses.KEY_RIGHT, ord("l"), ord("+")):
            _adjust(sel, STEP)
        elif k in (curses.KEY_LEFT, ord("h"), ord("-")):
            _adjust(sel, -STEP)
        elif k in (curses.KEY_NPAGE, ord(">")):
            _adjust(sel, BIG_STEP)
        elif k in (curses.KEY_PPAGE, ord("<")):
            _adjust(sel, -BIG_STEP)
        elif k in (ord("m"), ord("M")):
            if ITEMS[sel]["can_mute"]:
                ITEMS[sel]["mute"]()


if __name__ == "__main__":
    curses.wrapper(main)
