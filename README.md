# Web2App

Web2App is a simple TUI (Text User Interface) script that converts web applications into desktop apps.

## Features
- Create `.desktop` files for your favorite web apps
- Simple text-based menu interface
- Works with Google Chrome or Chromium

---

## Installation

### 1. From PKGBUILD (Arch Linux)
```bash
# Clone or download the project
git clone https://example.com/web2app.git
cd web2app

# Build and install
makepkg -si
```

### 2. AUR Helper (if published to AUR)
```bash
yay -S web2app
```

---

## Dependencies
- `bash`
- `xdg-utils`
- `desktop-file-utils`
- `google-chrome` **or** `chromium`

---

## Usage
Run:
```bash
web2app
```

The script will guide you through:
1. Entering the web app name
2. Providing the web app URL
3. Choosing an icon (optional)
4. Creating the desktop shortcut

The `.desktop` file will be saved to your local applications folder so it appears in your app launcher.

---

## Removal
If you want to remove an app created with Web2App, run:
```bash
/usr/share/web2app/remove.sh
```
and follow the instructions.

---

## License
Specify your license here.

---

## Author
Maintained by: **Your Name**
