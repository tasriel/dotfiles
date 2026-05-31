#!/bin/bash

# install basic requirements
# sudo apt install -y git stow tmux curl xclip

SCRIPTS=(
    "install_rust.sh"
    "install_lazygit.sh"
    "install_yazi.sh"
)

TOTAL_SCRIPTS=${#SCRIPTS[@]}
CURRENT=0
FAILED_SCRIPT=""

# Get the directory of the current script to ensure it runs from anywhere
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Calculate how many lines the header needs
# 5 fixed lines (headers/borders) + number of scripts + 3 lines for progress bar
HEADER_LINES=$(( 5 + TOTAL_SCRIPTS + 3 ))
START_LINE_OUTPUT=$(( HEADER_LINES + 1 ))

# Helper function to reset terminal scrolling behavior on exit
cleanup() {
    printf "\033[r" # Reset scrolling region to full screen
    clear
}
trap cleanup EXIT

# Function to render the overview and the progress bar
render_header() {
    # Move cursor to top-left (Line 1, Column 1) without clearing the whole screen
    printf "\033[1;1H"
    
    echo "========================================="
    echo "       DOTFILES SETUP PROGRESS          "
    echo "========================================="
    
    # Print the status of each script
    local idx=0
    for s in "${SCRIPTS[@]}"; do
        if [ $idx -lt $CURRENT ]; then
            echo -e "  [\e[32m✔\e[0m] $s (Installed)     "
        elif [ $idx -eq $CURRENT ] && [ "$1" == "show_current" ]; then
            echo -e "  [\e[33m➜\e[0m] \e[1;33m$s (Installing...)\e[0m"
        elif [ "$1" == "failed" ] && [ "$s" == "$FAILED_SCRIPT" ]; then
            echo -e "  [\e[31m✘\e[0m] \e[1;31m$s (FAILED)\e[0m        "
        else
            echo -e "  [ ] $s (Pending)     "
        fi
        ((idx++))
    done
    echo "-----------------------------------------"

    # CONDITION 2: Calculate and draw the progress bar
    local percent=$(( (CURRENT * 100) / TOTAL_SCRIPTS ))
    local bar_length=20
    local filled=$(( (CURRENT * bar_length) / TOTAL_SCRIPTS ))
    local empty=$(( bar_length - filled ))
    
    printf " Progress: ["
    printf "%${filled}s" | tr ' ' '#'
    printf "%${empty}s" | tr ' ' '-'
    printf "] %d%%\n" "$percent"
    echo "========================================="
}

# 1. Clear screen ONCE at the very beginning
clear

# 2. Set the scrolling region PERMANENTLY for the whole lifecycle of the script
printf "\033[%d;r" "$START_LINE_OUTPUT"

# Main installation loop
for script in "${SCRIPTS[@]}"; do
    # Update the frozen header at the top
    render_header "show_current"
    
    # Move cursor to the first line of the output region and clear old output
    printf "\033[%d;1H" "$START_LINE_OUTPUT"
    printf "\033[J"

    # Check if the script exists and is executable
    if [ -x "$SCRIPT_DIR/$script" ]; then
        # CONDITION 3: Live output runs natively inside the lower scrolling region
        "$SCRIPT_DIR/$script"
        EXIT_CODE=$?
    else
        echo -e "\e[31mError: $script is not executable or does not exist.\e[0m"
        EXIT_CODE=1
    fi

    # ERROR HANDLING: Immediately abort if a script fails
    if [ $EXIT_CODE -ne 0 ]; then
        FAILED_SCRIPT="$script"
        printf "\033[r" # Reset layout so error message is visible at the bottom
        render_header "failed"
        printf "\033[%d;1H" "$START_LINE_OUTPUT"
        echo -e "\e[31;1mSetup aborted! Error in script: $script (Exit Code: $EXIT_CODE)\e[0m"
        exit $EXIT_CODE
    fi

    # Increment the counter for the finished script
    ((CURRENT++))
done

# Reset terminal layout, clear, and show 100% success
printf "\033[r"
clear
CURRENT=$TOTAL_SCRIPTS
render_header "completed"
echo -e "\e[32;1mSetup completed successfully!\e[0m"
