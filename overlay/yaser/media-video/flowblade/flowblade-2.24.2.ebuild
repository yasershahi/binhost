# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_14 )
inherit desktop python-single-r1 xdg

DESCRIPTION="Multitrack non-linear video editor"
HOMEPAGE="https://github.com/jliljebl/flowblade"
SRC_URI="https://github.com/jliljebl/flowblade/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/flowblade-trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	x11-libs/gtk+:3[introspection]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	')
	media-libs/mlt[ffmpeg,python]
	media-video/ffmpeg"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# Gentoo's MLT bindings are named 'mlt', upstream expects 'mlt7' (same API v7)
	grep -rl "mlt7" --include="*.py" . | xargs sed -i "s/mlt7/mlt/g"
}

src_install() {
	insinto /usr/share/${PN}
	doins -r Flowblade docs
	dobin flowblade
	domenu installdata/io.github.jliljebl.Flowblade.desktop
	doicon -s 128 installdata/io.github.jliljebl.Flowblade.png
	doman installdata/flowblade.1
	insinto /usr/share/mime/packages
	doins installdata/io.github.jliljebl.Flowblade.xml
	insinto /usr/share/metainfo
	doins installdata/io.github.jliljebl.Flowblade.appdata.xml
}
