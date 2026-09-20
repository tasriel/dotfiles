#!/usr/bin/env bash
# Polybar volume module — event-driven, tracks the current default
# sink (no pinned sink needed).
#
# Force English pactl output regardless of system locale (e.g. German)
# — otherwise event text like "Event 'change' on sink" becomes
# "Ereignis »ändern« auf Ziel" and none of the pattern matching below
# would ever fire.
export LC_ALL=C
#
# Fill in your real Nerd Font icons below.
ICON_LOW=""               # built-in output, low volume
ICON_MED=""               # built-in output, medium volume
ICON_HIGH=""              # built-in output, high volume
ICON_MUTED=""
ICON_HEADPHONE=""   # external headphones / audio output

# Replace with the actual hex value of ${color.red} from your polybar
# color config — inline formatting tags need a literal hex code.
MUTED_COLOR="#f7768e"

UI_MAX=100   # PA_VOLUME_UI_MAX, in percent
STEP=5       # interval

current_sink() {
    # `pactl get-default-sink` isn't reliably supported under
    # pipewire-pulse; `pactl info` has been around forever and works
    # everywhere.
    local sink
    sink=$(pactl info 2>/dev/null | sed -n 's/^Default Sink: //p')
 
    # Fall back if the reported default sink no longer exists — e.g.
    # right after a Bluetooth device disconnects, "Default Sink:" can
    # keep pointing at the now-gone bluez sink for a while.
    if [[ -z "$sink" ]] || ! pactl list short sinks 2>/dev/null | awk '{print $2}' | grep -qx "$sink"; then
        sink=$(pactl list short sinks 2>/dev/null | awk 'NR==1{print $2}')
    fi
 
    echo "$sink"
}
 
current_volume() {
    pactl get-sink-volume "$1" 2>/dev/null | grep -oP '\d+%' | head -n1 | tr -d '%'
}
 
# "External" output -> headphone icon. Covers:
#   - Bluetooth devices (sink name contains "bluez")
#   - USB audio interfaces/DACs, e.g. your Behringer (name contains "usb")
#   - the laptop's own 3.5mm combo jack, once headphones are plugged in
#     (built-in sink switches its Active Port to analog-output-headphones)
is_headphone_output() {
    local sink="$1" port
 
    if [[ "$sink" == *bluez* || "$sink" == *usb* ]]; then
        return 0
    fi
 
    port=$(pactl list sinks | awk -v s="$sink" '
        $0 ~ "Name: " s "$" { found=1 }
        found && /Active Port:/ { print; exit }
    ')
    [[ "$port" == *[Hh]eadphone* ]]
}
 
print_volume() {
    local sink volume mute icon
    sink=$(current_sink)
 
    mute=$(pactl get-sink-mute "$sink" 2>/dev/null | grep -oP '(yes|no)')
    if [ "$mute" = "yes" ]; then
        echo "%{F${MUTED_COLOR}}${ICON_MUTED} Muted%{F-}"
        return
    fi
 
    volume=$(current_volume "$sink")
    volume=${volume:-0}
 
    # Enforce UI_MAX regardless of how the volume was raised (scroll
    # on this module, a keyboard shortcut, a GUI mixer, ...).
    if (( volume > UI_MAX )); then
        pactl set-sink-volume "$sink" "${UI_MAX}%"
        volume=$UI_MAX
    fi
 
    if is_headphone_output "$sink"; then
        icon="$ICON_HEADPHONE"
    elif (( volume <= 33 )); then
        icon="$ICON_LOW"
    elif (( volume <= 66 )); then
        icon="$ICON_MED"
    else
        icon="$ICON_HIGH"
    fi
 
    echo "${icon} ${volume}%"
}
 
# Click/scroll actions, called as: volume.sh <action>
case "$1" in
    up)
        sink=$(current_sink)
        current=$(current_volume "$sink")
        target=$(( current + STEP ))
        (( target > UI_MAX )) && target=$UI_MAX
        pactl set-sink-volume "$sink" "${target}%"
        exit 0
        ;;
    down)
        sink=$(current_sink)
        pactl set-sink-volume "$sink" -"${STEP}"%
        exit 0
        ;;
    toggle-mute)
        sink=$(current_sink)
        pactl set-sink-mute "$sink" toggle
        exit 0
        ;;
esac
 
# Default mode (no argument): print current state, then keep running
# and re-print on every relevant PulseAudio/PipeWire event.
print_volume
 
# `stdbuf -oL` forces pactl to flush its output line-by-line. Without
# it, pactl's stdout is fully block-buffered because it's writing to a
# pipe rather than a terminal, so subscribe events pile up in that
# buffer and never reach the `read` below — which is exactly why the
# module wasn't updating on volume changes.
stdbuf -oL pactl subscribe 2>/dev/null | while read -r line; do
    case "$line" in
        *"on sink"*|*"on server"*)
            print_volume
            ;;
    esac
done
