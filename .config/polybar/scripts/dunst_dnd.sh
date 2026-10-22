#!/bin/bash
# Helper for the polybar notification module
#
# Usage:
#   dnd.sh watch                 print the status icon on every change (polybar tail mode)
#   dnd.sh status                print the status icon once
#   dnd.sh display-history [N]   show the last N notifications again (all if N is empty)
#   dnd.sh close-history         close all currently displayed notifications
#   dnd.sh toggle-history        close displayed notifications, or show the history if none are shown

readonly command="$1"
readonly max_display_count="$2"

# How often the status is refreshed without a click (seconds)
readonly STATUS_REFRESH_SECONDS=1
# How long popups stay visible when the history is shown during DND (seconds)
readonly DND_PEEK_SECONDS=8

# Nerd Font icons (written as codepoints to avoid copy/paste problems)
readonly ICON_BELL_FILLED="󰂚"
readonly ICON_BELL_OUTLINE="󰂜"
readonly ICON_BELL_OFF="󰪑"

show_status() {
  local history_count
  history_count="$(dunstctl count history)"

  if [ "$(dunstctl is-paused)" = "true" ]; then
    echo "$ICON_BELL_OFF"
  elif [ "$history_count" -gt 0 ]; then
    echo "$ICON_BELL_FILLED"
  else
    echo "$ICON_BELL_OUTLINE"
  fi
}

watch_status() {
  # SIGUSR1 (sent by a polybar click) only ends the wait early,
  # so the loop prints a fresh status immediately
  trap ':' USR1

  while true; do
    show_status
    sleep "$STATUS_REFRESH_SECONDS" &
    wait $!
  done
}

display_history() {
  local notification_ids
  local was_paused=false

  # DND hides all popups, so let them through for a moment
  if [ "$(dunstctl is-paused)" = "true" ]; then
    was_paused=true
    dunstctl set-paused false
  fi

  # IDs of all notifications in the history
  notification_ids="$(dunstctl history | jq -r '.data[0][].id.data')"

  # Optionally limit how many notifications are shown
  if [ -n "$max_display_count" ]; then
    notification_ids="$(echo "$notification_ids" | head -n "$max_display_count")"
  fi

  # Pop each notification from the history back onto the screen
  for notification_id in $notification_ids; do
    dunstctl history-pop "$notification_id"
  done

  # Restore DND after the popups had time to be read
  if [ "$was_paused" = true ]; then
    sleep "$DND_PEEK_SECONDS"
    dunstctl set-paused true
  fi
}

close_history() {
  dunstctl close-all
}

toggle_history() {
  # Closed notifications go back into the history, so closing acts as collapsing
  if [ "$(dunstctl count displayed)" -gt 0 ]; then
    close_history
  else
    display_history
  fi
}

case "$command" in
  watch)           watch_status ;;
  display-history) display_history ;;
  close-history)   close_history ;;
  toggle-history)  toggle_history ;;
  *)               show_status ;;
esac
