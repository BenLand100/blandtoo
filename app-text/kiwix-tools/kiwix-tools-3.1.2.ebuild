# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson

DESCRIPTION="kiwix-tools"
HOMEPAGE="https://github.com/kiwix/kiwix-tools"
SRC_URI="https://github.com/kiwix/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/kiwix-lib
		net-libs/libmicrohttpd
		sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
}

src_configure() {
	meson_src_configure
}

src_compile() {
	default
}
