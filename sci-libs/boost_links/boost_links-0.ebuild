# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit python-single-r1

KEYWORDS="amd64"

DESCRIPTION="Creates boost_numpy and boost_python default links"
LICENSE="GPL-2"
SLOT="0"

IUSE="+python +numpy"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
$(python_gen_cond_dep 'dev-libs/boost[${PYTHON_USEDEP}]')
python? ( dev-libs/boost[python] )
numpy? ( dev-libs/boost[numpy] )"

DEPEND=""

src_unpack() {
	mkdir ${P}
}

src_install() {
	PYVER=`echo $EPYTHON | sed -E 's/python|\.//g'`
	mkdir -p ${D}/usr/lib64/
	if use python; then 
		ln -s libboost_python${PYVER}.so ${D}/usr/lib64/libboost_python.so
	fi
	if use numpy; then
		ln -s libboost_numpy${PYVER}.so ${D}/usr/lib64/libboost_numpy.so
	fi
}

