#!/usr/bin/env bash

dir="$HOME/.config/polybar"
themes=(`ls --hide="launch.sh" $dir`)

launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Launch the bar on every monitor connected
	for m in $(xrandr --query | grep " connected" | awk '{print $1}'); do
        MONITOR=$m polybar --reload main -c "$dir/$style/config.ini" &
    done
}


if [[ "$1" == "--grayblocks" ]]; then
	style="grayblocks"
	launch_bar

else
	cat <<- EOF
	Usage : launch.sh --theme
		
	Available Theme: --grayblocks
	EOF
fi
