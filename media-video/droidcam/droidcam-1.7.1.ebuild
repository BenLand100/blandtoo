# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

MODULE_NAMES="v4l2loopback-dc(media/video:v4l2loopback:v4l2loopback)"

DESCRIPTION="Use an Android phone as a webcam"
HOMEPAGE="www.dev47apps.com"
SRC_URI="${P}.tar.gz"
RESTRICT="fetch"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-libs/gtk+:2 \
		media-video/ffmpeg \
		dev-libs/glib \
		app-pda/usbmuxd \
		media-libs/speex \
		media-libs/libjpeg-turbo[static-libs]"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	unpack ${A}
	mv ${PN}* ${P}
}


src_compile() {
	echo "Building Client"
	emake all
	echo "Building Module"
	KERNEL_VER="${KV_FULL}" linux-mod_src_compile KERNEL_VER="${KV_FULL}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/" install
	linux-mod_src_install
	mkdir -p ${D}/etc/modules-load.d/
	echo "v4l2loopback_dc" >> ${D}/etc/modules-load.d/droidcam.conf
	mkdir -p ${D}/etc/modprobe.d/
	echo "options v4l2loopback_dc width=640 height=480" >> ${D}/etc/modprobe.d/droidcam.conf
}
