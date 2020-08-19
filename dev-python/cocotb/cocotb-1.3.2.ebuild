# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Coroutine based cosimulation library"
HOMEPAGE="https://github.com/cocotb/cocotb"
SRC_URI="https://github.com/cocotb/cocotb/archive/v${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-lang/python
	sys-devel/gcc"
DEPEND="${RDEPEND}"


python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_configure() {
	echo configured
}

python_install_all() {
	distutils-r1_python_install_all
}
