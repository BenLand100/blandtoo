# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qmake-utils

DESCRIPTION="kiwix-dekstop"
HOMEPAGE="https://github.com/kiwix/kiwix-desktop"
SRC_URI="https://github.com/kiwix/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/kiwix-lib
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwebengine:5
		dev-qt/qtsvg:5
		net-misc/aria2[bittorrent,xmlrpc]"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
}

src_configure() {
	eqmake5
}

src_compile() {
	default
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
