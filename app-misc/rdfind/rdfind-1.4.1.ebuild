# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7


DESCRIPTION="Find duplicate files utility"
HOMEPAGE="https://github.com/pauldreik/rdfind"
SRC_URI="https://github.com/pauldreik/${PN}/archive/refs/tags/releases/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/nettle"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	default
	mv "$PN-releases-$PV" "$PN-$PV"
}

src_prepare() {
	default
	autoreconf -i
}

src_configure() {
	default
	./configure --prefix=/usr
}
