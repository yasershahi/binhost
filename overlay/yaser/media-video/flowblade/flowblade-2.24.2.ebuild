# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_14 )
DISTUTILS_USE_PEP517=no
inherit distutils-r1 xdg

DESCRIPTION="Multitrack non-linear video editor"
HOMEPAGE="https://github.com/jliljebl/flowblade"
SRC_URI="https://github.com/jliljebl/flowblade/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${PYTHON_DEPS}
	x11-libs/gtk+:3[introspection]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	media-libs/mlt[ffmpeg,python]
	media-video/ffmpeg"
DEPEND="${RDEPEND}"
