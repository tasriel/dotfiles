#!/bin/bash

wallpaper_config="$HOME/dotfiles/.config/wallpaper"
curr_wallpaper_folder="$wallpaper_config/outset-island-zelda-windwaker"

function setbg {
    cp "$1" "$wallpaper_config/current.jpg"

    # Laufendes swaybg im Hintergrund beenden und neues starten
    pkill swaybg || true
    swaybg -i "$wallpaper_config/current.jpg" -m fill &

    # create blurred version of the wallpaper (for i3lock)
    convert "$wallpaper_config/current.jpg" -blur 0x8 "$wallpaper_config/current_blurred.jpg"
}

hour=$(date +%H)
time_of_day=$(sunwait poll 52.5173885N 13.3951309E)

[[ $time_of_day == "DAY" ]] && [ $hour -lt 12 ] && setbg "$curr_wallpaper_folder/morning.png"
[ $hour -gt 11 ] && [ $hour -lt 15 ]              && setbg "$curr_wallpaper_folder/midday.png"
[ $hour -gt 14 ] && [[ $time_of_day == "DAY" ]] && setbg "$curr_wallpaper_folder/dusk.png"
[[ $time_of_day == "NIGHT" ]]                   && setbg "$curr_wallpaper_folder/night.png"
