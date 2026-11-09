#!/usr/bin/env bash
# set-wallpaper-overview.sh
#
# Syncs the niri "overview" wallpaper with the desktop wallpaper set by waypaper.
#
# waypaper only sets the default `awww-daemon` (the sharp desktop wallpaper).
# This script is wired into waypaper's `post_command` so that, after waypaper
# sets a new wallpaper, we blur that same image and apply it to the separate
# `awww-daemon -n overview` daemon (which niri places within the backdrop).
#
# Usage (called automatically by waypaper via post_command):
#   set-wallpaper-overview.sh $wallpaper
#
# Blur strength can be overridden with the OVERVIEW_BLUR_SIGMA env var.

set -euo pipefail

WALLPAPER="${1:-}"

if [[ -z "$WALLPAPER" ]]; then
    echo "Usage: $0 <wallpaper-path>" >&2
    exit 1
fi

if [[ ! -f "$WALLPAPER" ]]; then
    echo "error: not a file: $WALLPAPER" >&2
    exit 1
fi

# Resolve to an absolute path in case waypaper passes a relative one.
WALLPAPER="$(realpath -- "$WALLPAPER")"

# Gaussian blur sigma; higher = stronger blur.
SIGMA="${OVERVIEW_BLUR_SIGMA:-25}"

# Cache dir for the blurred image, keyed by the source path so re-setting the
# same wallpaper reuses the blurred copy.
#
# IMPORTANT: this must live on a persistent filesystem. $XDG_RUNTIME_DIR (tmpfs)
# is wiped on reboot, and awww's overview daemon remembers the blurred image's
# absolute path across reboots — if the file vanished, the overview wallpaper
# falls back to a black background.
BLUR_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/niri-overview-wallpaper"
mkdir -p "$BLUR_DIR"

KEY="$(printf '%s' "$WALLPAPER" | sha256sum | cut -c1-16)"
OUTPUT="$BLUR_DIR/overview-$KEY.png"

# Blur the source image with ffmpeg (ImageMagick is not installed here).
if ! ffmpeg -y -loglevel error -i "$WALLPAPER" \
        -vf "gblur=sigma=$SIGMA" \
        -frames:v 1 "$OUTPUT"; then
    echo "error: ffmpeg failed to blur $WALLPAPER" >&2
    exit 1
fi

# Apply the blurred image to the overview daemon, matching waypaper's
# crop + Lanczos3 settings. Instant transition (overview is only shown on
# demand, so no transition is needed).
if ! awww img -n overview "$OUTPUT" \
        --resize crop \
        --filter Lanczos3 \
        --transition-type none; then
    echo "error: awww failed to set overview wallpaper" >&2
    exit 1
fi

echo "Overview wallpaper set (blurred): $OUTPUT"
