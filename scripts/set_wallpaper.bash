wallpaper_config=$HOME/dotfiles/.config/wallpaper
curr_wallpaper_folder=$wallpaper_config/outset-island-zelda-windwaker

function setbg {
  cp $1 $wallpaper_config/current.jpg
  DISPLAY=:0.0 feh --bg-scale $wallpaper_config/current.jpg
  # notify-send "wallpaper changed"
}


hour=$(date +%H)
time_of_day=$(sunwait poll 52.5173885N 13.3951309E)
[[ $time_of_day == "DAY" ]] && [ $hour -lt 12 ] && setbg $curr_wallpaper_folder/morning.png # morning
[ $hour -gt 11 ] && [ $hour -lt 15 ]            && setbg $curr_wallpaper_folder/midday.png # midday
[ $hour -gt 14 ] && [[ $time_of_day == "DAY" ]] && setbg $curr_wallpaper_folder/dusk.png # dusk
[[ $time_of_day == "NIGHT" ]]                   && setbg $curr_wallpaper_folder/night.png # night
