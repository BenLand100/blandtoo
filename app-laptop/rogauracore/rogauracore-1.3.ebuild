# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7


DESCRIPTION="RGB keyboard control for Asus ROG laptops"
HOMEPAGE="https://github.com/wroberts/rogauracore"
SRC_URI="https://github.com/wroberts/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz" 

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	autoreconf -i
}

src_configure() {
	default
	./configure --prefix=/usr
}

src_compile() {
	make
}
