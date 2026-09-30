# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_VERSION="152"
CHROMIUM_LANGS="
	af
	am
	ar
	bg
	bn
	ca
	ca-valencia
	cs
	da
	de
	de-CH
	el
	en-GB
	en-US
	eo
	es
	es-419
	es-PE
	et
	fa
	fi
	fil
	fr
	fy
	gd
	gu
	he
	hi
	hr
	hu
	id
	io
	it
	ja
	jbo
	kab
	kmr
	kn
	ko
	lt
	lv
	ml
	mr
	ms
	nb
	nl
	nn
	pl
	pt-BR
	pt-PT
	ro
	ru
	sc
	sk
	sl
	sr
	sv
	sw
	ta
	te
	th
	tr
	uk
	ur
	vi
	zh-CN
	zh-TW
"

inherit chromium-2 desktop linux-info toolchain-funcs unpacker xdg

# Upstream binary lives in /opt/vivaldi; this package keeps those paths
# (do NOT install www-client/vivaldi alongside it).
VIVALDI_HOME="opt/vivaldi"
DESCRIPTION="Vivaldi web browser (upstream prebuilt .deb)"
HOMEPAGE="https://vivaldi.com/"
SRC_URI="https://downloads.vivaldi.com/stable/vivaldi-stable_${PV}-1_amd64.deb"

S="${WORKDIR}"
LICENSE="Vivaldi"
SLOT="0"
KEYWORDS="~amd64"
IUSE="proprietary-codecs qt6 widevine"
RESTRICT="bindist mirror"

RDEPEND="
	!www-client/vivaldi
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
	x11-libs/gtk+:3
	proprietary-codecs? ( media-video/ffmpeg-chromium:${CHROMIUM_VERSION} )
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
	widevine? ( www-plugins/chrome-binary-plugins )
"

QA_PREBUILT="*"
CONFIG_CHECK="~CPU_FREQ"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	# Rename docs directory to our needs.
	mv usr/share/doc/{vivaldi-stable,${PF}}/ || die

	# Decompress the docs.
	gunzip usr/share/doc/${PF}/changelog.gz || die

	# The appdata directory is deprecated.
	mv usr/share/{appdata,metainfo}/ || die

	# Remove cron job for updating from Debian repos.
	rm etc/cron.daily/vivaldi ${VIVALDI_HOME}/cron/vivaldi || die
	rmdir etc/{cron.daily/,} ${VIVALDI_HOME}/cron/ || die

	# Remove scripts that will most likely break things.
	rm -vf ${VIVALDI_HOME}/update-ffmpeg || die

	pushd ${VIVALDI_HOME}/locales > /dev/null || die
	rm ja-KS.pak ja-KS_*.pak || die # No flag for Kansai as not in IETF list.
	chromium_remove_language_paks
	popd > /dev/null || die

	if use proprietary-codecs; then
		einfo Bundled $($(tc-getSTRINGS) ${VIVALDI_HOME}/libffmpeg.so | grep -m1 "^FFmpeg version ")
		rm ${VIVALDI_HOME}/libffmpeg.so || die
	fi

	# Qt5 is obsolete now.
	rm ${VIVALDI_HOME}/libqt5_shim.so || die

	if ! use qt6; then
		rm ${VIVALDI_HOME}/libqt6_shim.so || die
	fi

	# Point the shipped .desktop entry at our /usr/bin launcher.
	sed -i 's|/usr/bin/vivaldi-stable|/usr/bin/vivaldi-bin|' \
		usr/share/applications/vivaldi-stable.desktop || die

	eapply_user
}

src_install() {
	mv */ "${D}" || die
	dosym ../../${VIVALDI_HOME}/vivaldi /usr/bin/vivaldi-bin
	fperms 4711 /${VIVALDI_HOME}/vivaldi-sandbox

	local logo size
	for logo in "${ED}"/${VIVALDI_HOME}/product_logo_*.png; do
		size=${logo##*_}
		size=${size%.*}
		newicon -s "${size}" "${logo}" ${PN}.png
	done

	if use proprietary-codecs; then
		dosym ../../usr/$(get_libdir)/chromium/libffmpeg.so.${CHROMIUM_VERSION} \
			/${VIVALDI_HOME}/libffmpeg.so.$(ver_cut 1-2)
	fi

	if use widevine; then
		dosym ../../usr/$(get_libdir)/chromium-browser/WidevineCdm \
			/${VIVALDI_HOME}/WidevineCdm
	fi
}
