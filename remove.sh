#!/bin/bash

clear

ascii_art="
   /\         /\         /\   
  /  \   /\  /  \   /\  /  \  
 / /\ \ /  \/ /\ \ /  \/ /\ \ 
/ /  \ \   / /  \ \   / /  \ \  
        A M B E R W O O D         
"

title="Web2App - Remove App"

tput civis  # Hide cursor

draw_screen() {
     clear
     echo "$ascii_art"
     echo "======= $title ======="
     echo
     echo "Press 'ESC' at any time to quit."
     echo
}

# List all .desktop files created by the add script
list_webapps() {
     find "$HOME/.local/share/applications" -maxdepth 1 -type f -name "*.desktop" | \
     while read -r file; do
          # Only show those with Exec line containing chromium and --app
          if grep -q 'Exec=.*chromium.*--app=' "$file"; then
                # Print file name without path and extension
                basename "${file%.desktop}"
          fi
     done
}

# Custom input function for ESC detection
custom_read_input() {
     local prompt="$1"
     local __resultvar="$2"
     local input=""
     local char
     echo -n "$prompt"
     tput cnorm
     while true; do
          IFS= read -rsn1 char
          if [[ $char == $'\e' ]]; then
                tput cnorm
                clear
                exit
          elif [[ -z $char ]]; then
                echo
                break
          elif [[ $char == $'\177' ]]; then
                if [ -n "$input" ]; then
                     input="${input%?}"
                     echo -ne "\b \b"
                fi
          else
                input+="$char"
                echo -n "$char"
          fi
     done
     eval "$__resultvar=\"$input\""
}

trap "tput cnorm; clear; exit" INT TERM

draw_screen

echo "Installed Web Apps:"
echo

webapps=()
while IFS= read -r app; do
     webapps+=("$app")
done < <(list_webapps)

if [ ${#webapps[@]} -eq 0 ]; then
     echo "No Web Apps found."
     tput cnorm
     exit 0
fi

for i in "${!webapps[@]}"; do
     printf "  [%d] %s\n" "$((i+1))" "${webapps[$i]}"
done

echo
custom_read_input "Enter the number of the app to remove: " APP_IDX

if ! [[ "$APP_IDX" =~ ^[0-9]+$ ]] || [ "$APP_IDX" -lt 1 ] || [ "$APP_IDX" -gt "${#webapps[@]}" ]; then
     echo "Invalid selection."
     tput cnorm
     exit 1
fi

APP_NAME="${webapps[$((APP_IDX-1))]}"
DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
ICON_PATH="$HOME/.local/share/applications/icons/${APP_NAME}.png"

draw_screen
echo "Selected App: $APP_NAME"
echo
custom_read_input "Are you sure you want to remove this app? (y/N): " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
     echo "Aborted."
     tput cnorm
     exit 0
fi

rm -f "$DESKTOP_FILE"
rm -f "$ICON_PATH"

# Optionally update desktop database
if command -v update-desktop-database >/dev/null 2>&1; then
     update-desktop-database "$HOME/.local/share/applications" || true
fi

echo
echo "✅ $APP_NAME has been removed."
tput cnorm
exit 0