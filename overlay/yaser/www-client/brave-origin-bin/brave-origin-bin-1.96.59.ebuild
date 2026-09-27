# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Minimalist Brave: best-in-class privacy, just the features you want"
HOMEPAGE="https://brave.com/origin/"
SRC_URI="https://github.com/brave/brave-browser/releases/download/v${PV}/brave-origin-${PV}-linux-amd64.zip"
S="${WORKDIR}"

LICENSE="MPL-2.0"
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
	# Binary bundle: preserve upstream permissions, then fix the sandbox
	mkdir -p "${ED}/opt/brave-origin" || die
	cp -a "${S}/"* "${ED}/opt/brave-origin/" || die
	fperms 4755 /opt/brave-origin/chrome-sandbox
	dosym ../brave-origin/brave-origin /usr/bin/brave-origin
	newicon "${S}"/product_logo_128.png brave-origin.png
	make_desktop_entry "brave-origin %U" "Brave Origin" brave-origin "Network;WebBrowser"
}
