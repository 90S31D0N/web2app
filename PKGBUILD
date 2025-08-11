# Maintainer: Your Name <you@example.com>
pkgname=web2app
pkgver=0.1.0
pkgrel=1
pkgdesc="Simple TUI to convert web applications into desktop apps"
arch=('any')
url="https://example.com/web2app"
license=('unknown')
depends=('bash' 'xdg-utils' 'desktop-file-utils' 'chromium')
optdepends=('xorg-xmessage: basic message dialogs'
            'zenity: GTK dialogs (if your script supports it)'
            'yad: Alternative GTK dialogs (if your script supports it)')
source=('web2app'
        'install.sh'
        'remove.sh'
        'README.md')
b2sums=('SKIP'
        'SKIP'
        'SKIP'
        'SKIP')

package() {
  install -d "${pkgdir}/usr/share/${pkgname}"

  # Main scripts live together so relative paths work
  install -m755 "web2app"   "${pkgdir}/usr/share/${pkgname}/web2app"
  install -m755 "install.sh" "${pkgdir}/usr/share/${pkgname}/install.sh"
  install -m755 "remove.sh"  "${pkgdir}/usr/share/${pkgname}/remove.sh"

  # Launcher in PATH that forwards args
  install -d "${pkgdir}/usr/bin"
  cat > "${pkgdir}/usr/bin/${pkgname}" << 'EOF'
#!/bin/bash
exec /usr/share/web2app/web2app "$@"
EOF
  chmod 755 "${pkgdir}/usr/bin/${pkgname}"

  # Docs
  install -d "${pkgdir}/usr/share/doc/${pkgname}"
  install -m644 "README.md" "${pkgdir}/usr/share/doc/${pkgname}/README.md"
}
