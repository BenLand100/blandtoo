# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="SuperSlicer gcode generator for 3D printers"
HOMEPAGE="https://github.com/supermerill/SuperSlicer/"
SRC_URI="https://github.com/supermerill/SuperSlicer/releases/download/${PV}/SuperSlicer_${PV}_linux64_240701.tar.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	default
	mkdir $P
	tar xf SuperSlicer* -C ./$P
	rm SuperSlicer*.tar
}

src_install() {
	local superdir=/opt/superslicer
	dodir $superdir
	
	# Hardcode install path
	sed -i "s:DIR=.*:DIR=${superdir}:" superslicer
	dobin superslicer
	
	exeinto $superdir/bin
	doexe bin/superslicer
	doexe bin/OCCTWrapper.so
	
	insinto $superdir
	doins -r resources

	exeinto /usr/share/applications
	newexe - SuperSlicer.desktop <<-EOF
		[Desktop Entry]
		Name=SuperSlicer
		Exec=/usr/bin/superslicer
		Icon=${superdir}/resources/icons/SuperSlicer_192px.png
		Type=Application
		Categories=Graphics;
		MimeType=model/stl;application/vnd.ms-3mfdocument;application/prs.wavefront-obj;application/x-amf;
	EOF

	exeinto /usr/share/applications
	newexe - SuperSlicer-gcodeviewer.desktop <<-EOF
		[Desktop Entry]
		Name=SuperSlicer - GCODE Viewer
		Exec=/usr/bin/superslicer --gcodeviewer
		Icon=${superdir}/resources/icons/SuperSlicer-gcodeviewer_192px.png
		Type=Application
		Categories=Graphics;
		MimeType=text/x.gcode;
	EOF
}
