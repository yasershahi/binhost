# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Visual Studio Code - code editor"
HOMEPAGE="https://code.visualstudio.com/"
SRC_URI="https://update.code.visualstudio.com/${PV}/linux-x64/stable -> vscode-${PV}.tar.gz"
S="${WORKDIR}/VSCode-linux-x64"

LICENSE="vscode"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"
QA_PREBUILT="*"

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango"

src_install() {
	mkdir -p "${ED}/opt/vscode" || die
	cp -a "${S}/"* "${ED}/opt/vscode/" || die
	dosym /opt/vscode/code /usr/bin/code
	newicon "${S}"/resources/app/resources/linux/code.png vscode.png
	make_desktop_entry "code --unity-launch %F" "Visual Studio Code" vscode "Development;IDE"
}
