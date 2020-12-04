# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1

DESCRIPTION="Manipulate arrays of complex data structures as easily as Numpy."
HOMEPAGE="https://github.com/scikit-hep/awkward-1.0"
SRC_URI="https://github.com/scikit-hep/awkward-1.0/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-libs/rapidjson"

src_unpack() {
	unpack ${A}
	mv awkward{-1.0,1}-${PV}
}

src_prepare() {
	sed -i -E 's/.*pybind11.*|.*rapidjson.*//g' CMakeLists.txt
	cat CMakeLists.*
	grep pybind11 CMakeLists.txt
	eapply_user
}
