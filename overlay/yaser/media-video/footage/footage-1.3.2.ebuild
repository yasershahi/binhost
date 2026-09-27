# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Simple video editor for Linux"
HOMEPAGE="https://github.com/adhami3310/Footage"
SRC_URI="https://github.com/adhami3310/Footage/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Footage-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	gui-libs/gtk:4[introspection]
	media-video/ffmpeg"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/meson
	dev-build/ninja
	virtual/pkgconfig"
