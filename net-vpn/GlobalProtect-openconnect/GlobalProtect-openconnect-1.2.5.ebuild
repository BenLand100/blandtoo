# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/yuezk/GlobalProtect-openconnect"
EGIT_REPO_URI="https://github.com/yuezk/${PN}"
EGIT_TAG="v${PV}"
#SRC_URI="https://github.com/yuezk/GlobalProtect-openconnect/archive/v${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-qt/qtwebsockets >=net-vpn/openconnect-8"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	eqmake5 CONFIG+=release
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
