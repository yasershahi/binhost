# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_14 )
inherit meson python-single-r1 xdg

DESCRIPTION="Calendar application for Linux desktops"
HOMEPAGE="https://github.com/xapp-project/clockenstein"
SRC_URI="https://github.com/xapp-project/clockenstein/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# NOTE: CalDAV backend needs dev-python/caldav (not in portage);
# Google/local calendars work without it.
RDEPEND="${PYTHON_DEPS}
	x11-libs/gtk+:3[introspection]
	x11-libs/xapp[introspection]
	$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/icalendar[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/google-api-python-client[${PYTHON_USEDEP}]
	')
	media-libs/gsound[introspection]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/meson
	dev-build/ninja
	virtual/pkgconfig
	dev-libs/gobject-introspection"

pkg_setup() {
	python-single-r1_pkg_setup
}
