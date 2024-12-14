# Maintainer: ttzztztz <ttzztztz@outlook.com>

pkgname=com.futu.ftnn.wine
pkgver=14.40.16258
pkgrel=1
pkgdesc="Futu Bull (FTNN) Wine unofficial version, use it at your own risk!"
arch=('x86_64')
url="https://github.com/ttzztztz/futu-ftnn-wine-arch"
install="com-futu-ftnn-wine.install"
license=('unknown')
depends=(
	'bash'
	'glibc'
    'wine'
    'wine-mono'
    'wqy-microhei'
)
source=(
	"https://softwaredownload.futunn.com/FTNN_${pkgver}.exe"
	"run.sh"
	"launcher.desktop"
	"cjk-font.reg"
)
optdepends=('winetricks: Recommended wine tools')

md5sums=(
	'3913a9aea280f60f4bf9acc0d3241b2f'
	'72b01d66a008f7f27c45b18d2a1abd0a'
	'f5f1458a11d24fad34e82e0bd91879dc'
	'fb0a1e6b6424501f81d88b61bd2e0fa8'
)

package() {
	install -d --mode=755 "${pkgdir}/usr/share/$pkgname/"
	install -d --mode=755 "${pkgdir}/usr/share/$pkgname/.wine"

	install -D --mode=644 "FTNN_$pkgver.exe" "$pkgdir/usr/share/$pkgname/FTNN_INSTALLER_$pkgver.exe"
  	install -D --mode=644 launcher.desktop "$pkgdir/usr/share/applications/$pkgname.desktop"
	install -D --mode=644 cjk-font.reg "$pkgdir/usr/share/$pkgname/cjk-font.reg"
	install -D --mode=755 "run.sh" -t "$pkgdir/usr/share/$pkgname"
  	sed -i "s/__PKG_NAME__/$pkgname/g" "$pkgdir/usr/share/$pkgname/run.sh"
  	sed -i "s/__PKG_VER__/$pkgver/g" "$pkgdir/usr/share/$pkgname/run.sh"
}
