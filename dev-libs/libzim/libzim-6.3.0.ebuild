# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson

DESCRIPTION="openzim"
HOMEPAGE="https://github.com/openzim/libzim"
SRC_URI="https://github.com/openzim/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/lzma
		dev-libs/icu
		app-arch/zstd
		dev-libs/xapian
		sys-fs/e2fsprogs"
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
