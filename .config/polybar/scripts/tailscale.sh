#!/usr/bin/env bash
# Tailscale-Status-Modul für polybar
# Voraussetzung: jq (sudo apt install jq)

if ! command -v tailscale &>/dev/null; then
    echo "%{F#f38ba8} kein tailscale%{F-}"
    exit 0
fi

state=$(tailscale status --json 2>/dev/null | jq -r '.BackendState')

case "$state" in
    Running)
        ip=$(tailscale ip -4 2>/dev/null)
        echo "󰦝 up"
        ;;
    Stopped)
        echo "󱦛 down"
        ;;
    NeedsLogin)
        echo "%{F#f9e2af} Login nötig%{F-}"
        ;;
    *)
        echo "%{F#f9e2af} $state%{F-}"
        ;;
esac
