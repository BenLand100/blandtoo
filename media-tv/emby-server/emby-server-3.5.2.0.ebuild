# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils user git-r3 dotnet

DESCRIPTION="Emby media and streaming server via debian package"
HOMEPAGE="http://emby.media/"
KEYWORDS="-* amd64 ~x86"
SRC_URI="https://github.com/MediaBrowser/Emby.Releases/releases/download/${PV}/emby-server-deb_${PV}_amd64.deb -> emby-server-${PV}.deb"
SLOT="0"
LICENSE="GPL-2"
IUSE=""
RESTRICT="mirror test"

RDEPEND=">=media-video/ffmpeg-2[vpx]
	media-gfx/imagemagick[jpeg,jpeg2k,webp,png]
	!media-tv/mediabrowser-server
	!media-tv/emby-server
	>=dev-db/sqlite-3.0.0
	dev-dotnet/referenceassemblies-pcl
	app-misc/ca-certificates"
DEPEND="app-arch/unzip ${RDEPEND}"

INSTALL_DIR="/opt/emby-server"
DATA_DIR="/var/lib/emby-server"
STARTUP_LOG="/var/log/emby-server_start.log"
INIT_SCRIPT="${ROOT}/etc/init.d/emby-server"

# INSTALL
# #######################################################################################################

pkg_setup() {
	einfo "creating user for Emby"
	enewgroup emby
	enewuser emby -1 /bin/bash ${INSTALL_DIR} "emby"
	einfo "updating root certificates for mono certificate store"
	addwrite "/usr/share/.mono/keypairs"
	dotnet_pkg_setup
	cert-sync /etc/ssl/certs/ca-certificates.crt
}

# gentoo expects a specific subfolder in the working directory for the extracted source, so simply extracting won't work here
src_unpack() {
	einfo ${A}
	unpack emby-server-${PV}.deb
	tar xf data.tar.*
	mv opt/emby-server emby-server-${PV}
}


src_install() {
	einfo "preparing startup scripts"
	newinitd "${FILESDIR}"/emby-server.init ${PN}
	newconfd "${FILESDIR}"/emby-server.conf ${PN}

	einfo "preparing startup log file"
	dodir /var/log/
	touch ${D}${STARTUP_LOG}
	chown emby:emby ${D}${STARTUP_LOG}

	einfo "installing compiled files"
	diropts -oemby -gemby
	dodir ${INSTALL_DIR}
	cp -R ${S}/* ${D}${INSTALL_DIR}/ || die "install failed, possibly compile did not succeed earlier?"
	chown emby:emby -R ${D}${INSTALL_DIR}

	einfo "prepare data directory"
	dodir ${DATA_DIR}
}

pkg_postinst() {
	einfo "emby-server was installed to ${INSTALL_DIR}, to start please use the init script provided."
	einfo "All data generated and used by Emby can be found at ${DATA_DIR} after the first start."
	einfo ""

	if [[ -d "/usr/lib/mediabrowser-server" || -h "/usr/lib/mediabrowser-server" ]]; then
		ewarn "ATTENTION: You seem to have moved from the former mediabrowser-server package:"
		ewarn "don't forget to migrate your original data directory before the first start!"
		ewarn "To do that move"
		ewarn "     /usr/lib/mediabrowser-server"
		ewarn "to"
		ewarn "     ${DATA_DIR}"
		ewarn "and change owner status from mediabrowser:mediabrowser to emby:emby!"
		ewarn "     chown -R emby:emby ${DATA_DIR}"
	fi

	if [[ -d "/usr/lib/emby-server" || -h "/usr/lib/emby-server"  ]]; then
		ewarn "ATTENTION: You seem to have existing program data at /usr/lib/emby-server!"
		ewarn "Please move that folder to ${DATA_DIR} before the first start and make sure the folder is owned by emby:emby"
		ewarn "The folder /usr/lib/emby-server will be repurposed in one of the next releases, so make sure to clean that directory up!"
	fi
}

# UNINSTALL
# #######################################################################################################

pkg_prerm() {
	einfo "Stopping running instances of Emby Server"
	if [ -e "${INIT_SCRIPT}" ]; then
		${INIT_SCRIPT} stop
	fi
}
