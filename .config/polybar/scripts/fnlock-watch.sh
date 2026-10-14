#!/usr/bin/env bash
# Fn-Lock-Indikator für polybar (Asus Vivobook) – reines Bash, keine Extra-Pakete.
#
# Die Firmware meldet den Fn-Lock-Zustand nicht an Linux. Das Skript leitet ihn
# deshalb aus der zuletzt gedrückten Taste der F-Reihe ab:
#
#   F1 ... F12                -> Fn-Lock AUS (F-Tasten aktiv)
#   Lautstärke/Helligkeit/... -> Fn-Lock AN  (Sonderfunktionen aktiv)
#
# Startzustand nach dem Hochfahren: Fn-Lock AUS.
#
# Auf Rechnern ohne Fn-Lock (z. B. Desktop) fehlt das Gerät MARKER_DEVICE. Das
# Skript gibt dann nur eine leere Zeile aus (polybar blendet das Modul aus) und
# wartet still – ohne Fehlermeldung und ohne von polybar neu gestartet zu werden.
#
# Einschränkung: Hältst du Fn gedrückt, um eine Sonderfunktion einmalig zu
# nutzen, sieht das für Linux genauso aus wie aktivierter Fn-Lock. Der Punkt
# springt dann um und korrigiert sich beim nächsten normalen F-Tastendruck.
#
# Gedacht für ein polybar-Modul mit `type = custom/script` und `tail = true`.
# Voraussetzung: Benutzer in der Gruppe `input`.
#
# Technik: Liest die rohen `struct input_event`s (24 Byte auf 64-Bit-Systemen)
# mit `od` aus /dev/input/eventX. Pro Event gibt od 12 Werte à 16 Bit aus:
#   [0-7] Zeitstempel, [8] type, [9] code, [10-11] value

set -u

# ----------------------------------------------------------------- Einstellungen

INITIAL_FN_LOCK=0   # 0 = nach dem Start F-Tasten aktiv, 1 = Sonderfunktionen

SYMBOL="●"
COLOR_ON="#a3be8c"      # Fn-Lock an (Sonderfunktionen)
COLOR_OFF="#4c566a"     # Fn-Lock aus (F-Tasten)
COLOR_ERROR="#bf616a"   # Keine Eingabegeräte lesbar

# Gerät, das nur auf dem Laptop existiert. Fehlt es, wird nichts angezeigt.
# ("Video Bus" oder eine PS/2-Tastatur gibt es oft auch am Desktop, daher
# taugen die nicht als Erkennungsmerkmal.)
MARKER_DEVICE="Asus WMI hotkeys"

# Geräte, auf denen F-Tasten bzw. Sonderfunktionen ankommen können
# (Namen wie in `sudo evtest` angezeigt).
DEVICE_NAMES=(
    "AT Translated Set 2 keyboard"
    "Asus WMI hotkeys"
    "Video Bus"
)

# Keycodes aus linux/input-event-codes.h (Leerzeichen am Anfang/Ende nötig).
# F1–F10 = 59–68, F11 = 87, F12 = 88
F_KEYS=" 59 60 61 62 63 64 65 66 67 68 87 88 "

# Sonderfunktionen der F-Reihe. Fehlende Tasten deines Modells per
# `sudo evtest` ermitteln (Zahl hinter "code") und hier ergänzen.
#   113 MUTE          114 VOLUMEDOWN     115 VOLUMEUP      248 MICMUTE
#   224 BRIGHTNESSDN  225 BRIGHTNESSUP   227 SWITCHVIDEO
#   228 KBDILLUMTOGGLE 229 KBDILLUMDOWN  230 KBDILLUMUP
#   530 TOUCHPAD_TOGGLE 212 CAMERA       585 EMOJI_PICKER  152 SCREENLOCK
#   163 NEXTSONG      164 PLAYPAUSE      165 PREVIOUSSONG  166 STOPCD
#   148 PROG1         149 PROG2          202 PROG3         203 PROG4
MEDIA_KEYS=" 113 114 115 248 224 225 227 228 229 230 530 212 585 152 163 164 165 166 148 149 202 203 "

EV_KEY=1
KEY_DOWN=1

# ------------------------------------------------------------------------- Logik

render() {
    local color
    if (( $1 )); then color=$COLOR_ON; else color=$COLOR_OFF; fi
    printf '%%{F%s}%s%%{F-}\n' "$color" "$SYMBOL"
}

# Erfolgreich, wenn dieser Rechner einen Fn-Lock hat (MARKER_DEVICE vorhanden).
# Mit gesetztem FNLOCK_DEVICES wird die Prüfung übersprungen.
has_fn_lock() {
    [[ -n "${FNLOCK_DEVICES:-}" ]] && return 0
    grep -qxF "N: Name=\"$MARKER_DEVICE\"" /proc/bus/input/devices 2>/dev/null
}

# Modul ausblenden und still weiterlaufen. Ein Beenden würde polybar
# (tail = true) dazu bringen, das Skript immer wieder neu zu starten.
hide_forever() {
    echo
    exec sleep infinity
}

# Gibt die /dev/input/eventX-Pfade aller Geräte aus DEVICE_NAMES aus.
# Zum Testen/Debuggen lässt sich die Liste per FNLOCK_DEVICES überschreiben.
find_devices() {
    if [[ -n "${FNLOCK_DEVICES:-}" ]]; then
        printf '%s\n' $FNLOCK_DEVICES
        return
    fi
    awk -v list="$(printf '%s\n' "${DEVICE_NAMES[@]}")" '
        BEGIN {
            n = split(list, names, "\n")
            for (i = 1; i <= n; i++) if (names[i] != "") want[names[i]] = 1
        }
        /^N: Name=/ {
            name = $0
            sub(/^N: Name="/, "", name)
            sub(/"$/, "", name)
        }
        /^H: Handlers=/ {
            if (!(name in want)) next
            line = $0
            sub(/^H: Handlers=/, "", line)
            m = split(line, handlers, " ")
            for (i = 1; i <= m; i++)
                if (handlers[i] ~ /^event[0-9]+$/) print "/dev/input/" handlers[i]
        }
    ' /proc/bus/input/devices
}

reader_pid=""
cleanup() {
    if [[ -n "$reader_pid" ]]; then
        pkill -P "$reader_pid" 2>/dev/null
        kill "$reader_pid" 2>/dev/null
    fi
}
trap cleanup EXIT
trap 'exit 0' TERM INT HUP

main() {
    has_fn_lock || hide_forever

    local devices=() dev
    while IFS= read -r dev; do
        [[ -r "$dev" ]] && devices+=("$dev")
    done < <(find_devices)

    if (( ${#devices[@]} == 0 )); then
        printf '%%{F%s}!%%{F-}\n' "$COLOR_ERROR"
        echo "fnlock-watch: keine lesbaren Eingabegeräte gefunden (Gruppe 'input'?)" >&2
        exit 1
    fi

    local state=$INITIAL_FN_LOCK
    render "$state"

    # Ein od pro Gerät, alle schreiben zeilenweise in dieselbe Pipe.
    local fd
    exec {fd}< <(
        for dev in "${devices[@]}"; do
            stdbuf -i0 -oL od -An -v -t u2 -w24 "$dev" &
        done
        wait
    )
    reader_pid=$!

    local w code new
    while read -r -a w <&"$fd"; do
        (( ${#w[@]} == 12 )) || continue
        (( w[8] == EV_KEY && w[10] == KEY_DOWN && w[11] == 0 )) || continue
        code=${w[9]}
        if [[ "$F_KEYS" == *" $code "* ]]; then
            new=0
        elif [[ "$MEDIA_KEYS" == *" $code "* ]]; then
            new=1
        else
            continue
        fi
        if (( new != state )); then
            state=$new
            render "$state"
        fi
    done
}

main
