#!/bin/bash

clear

ascii_art="
 __      __   _    ___   _             
 \ \    / /__| |__|_  ) /_\  _ __ _ __ 
  \ \/\/ / -_) '_ \/ / / _ \| '_ \ '_ \\
   \_/\_/\___|_.__/___/_/ \_\ .__/ .__/
                            |_|  |_|           
"

title="Web2App"

tput civis  # Hide cursor

draw_screen() {
    clear
    echo "$ascii_art"
    echo "========== $title =========="
    echo
    echo "Press 'ESC' at any time to quit."
    echo
}

# Custom input function that allows ESC detection and stores result in a variable
custom_read_input() {
    local prompt="$1"
    local __resultvar="$2"
    local placeholder="$3"
    local input=""
    local char
    local first_char=1
    echo -n "$prompt"
    if [ -n "$placeholder" ]; then
        # Print placeholder in gray
        echo -ne "\033[90m$placeholder\033[0m"
    fi
    tput cnorm  # Show cursor for input
    while true; do
        IFS= read -rsn1 char
        if [[ $char == $'\e' ]]; then
            tput cnorm
            clear
            exit
        elif [[ -z $char ]]; then  # Enter key
            echo
            break
        elif [[ $char == $'\177' ]]; then  # Handle backspace
            if [ $first_char -eq 0 ] && [ -n "$input" ]; then
                input="${input%?}"
                echo -ne "\b \b"
            fi
        else
            if [ $first_char -eq 1 ]; then
                # Clear placeholder
                if [ -n "$placeholder" ]; then
                    for ((i=0; i<${#placeholder}; i++)); do echo -ne "\b \b"; done
                fi
                first_char=0
            fi
            input+="$char"
            echo -n "$char"
        fi
    done
    eval "$__resultvar=\"$input\""
}

trap "tput cnorm; clear; exit" INT TERM

draw_screen

custom_read_input "Enter the app name: " APP_NAME
draw_screen
echo "App Name: $APP_NAME"

custom_read_input "Enter the app URL: " APP_URL
draw_screen
echo "App Name: $APP_NAME"
echo "App URL: $APP_URL"

custom_read_input "Enter the icon URL: " ICON_URL "https://dashboardicons.com/"
draw_screen
echo "App Name: $APP_NAME"
echo "App URL: $APP_URL"
echo "Icon URL: $ICON_URL"

SAFE_APP_ID="$(echo "$APP_NAME" | tr '[:space:]' '-' | tr -cd '[:alnum:]-_.' )"
ICON_DIR="$HOME/.local/share/applications/icons"
DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

mkdir -p "$ICON_DIR"

echo 
echo "Downloading icon from $ICON_URL..."
if ! curl -sL -o "$ICON_PATH" "$ICON_URL"; then
    echo "Error: Failed to download icon."
    exit 1
fi

echo "Icon downloaded to $ICON_PATH"
echo
echo "Creating desktop entry at $DESKTOP_FILE..."


cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME
Exec=chromium --new-window --ozone-platform=wayland --app="$APP_URL" --name="$SAFE_APP_ID" --class="$SAFE_APP_ID"
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupNotify=true
Categories=Network;WebBrowser;
EOF

chmod +x "$DESKTOP_FILE"
 

# Optionally update desktop database (if available)
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" || true
fi

echo "Desktop entry created."

echo
echo "✅ Success! $APP_NAME has been installed as a Web App."
tput cnorm
exit 0