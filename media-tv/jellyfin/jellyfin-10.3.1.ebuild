# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils user

DESCRIPTION="Jellyfin open source media server"
HOMEPAGE="http://jellyfin.media/"
KEYWORDS="-* amd64 ~x86"
SRC_URI="https://github.com/jellyfin/jellyfin/archive/v${PV}.tar.gz -> jellyfin-${PV}.tar.gz https://github.com/jellyfin/jellyfin-web/archive/v${PV}.tar.gz -> jellyfin-web-${PV}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
IUSE=""
RESTRICT="mirror test"

RDEPEND=">=media-video/ffmpeg-2[vpx]
	media-gfx/imagemagick[jpeg,jpeg2k,webp,png]
	>=dev-db/sqlite-3.0.0
	app-misc/ca-certificates"
DEPEND="app-arch/tar 
	|| ( dev-dotnet/dotnetcore-sdk-bin  dev-dotnet/dotnetcore-sdk )
	${RDEPEND}"

INSTALL_DIR="/opt/jellyfin"
DATA_DIR="/var/lib/jellyfin"
STARTUP_LOG="/var/log/jellyfin_start.log"
INIT_SCRIPT="${ROOT}/etc/init.d/jellyfin"

# INSTALL
# #######################################################################################################

pkg_setup() {
	einfo "creating user for Jellyfin"
	enewgroup jellyfin
	enewuser jellyfin -1 /bin/bash ${INSTALL_DIR} "jellyfin"
}

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1 #disable dotnet telemetry
	dotnet publish Jellyfin.Server --configuration Release --self-contained --runtime linux-x64 "-p:GenerateDocumentationFile=false;DebugSymbols=false;DebugType=none"
}

src_install() {
	einfo "preparing startup scripts"
	newinitd "${FILESDIR}"/jellyfin.init ${PN}

	einfo "preparing startup log file"
	dodir /var/log/
	touch ${D}${STARTUP_LOG}
	chown jellyfin:jellyfin ${D}${STARTUP_LOG}

	einfo "installing compiled files"
	diropts -ojellyfin -gjellyfin
	dodir ${INSTALL_DIR}
	cp -R ${S}/Jellyfin.Server/bin/Release/netcoreapp2.1/linux-x64/publish/* ${D}${INSTALL_DIR}/ || die "install failed. no build found."
	cp -R ${S}/../jellyfin-web-${PV}/src ${D}${INSTALL_DIR}/web || die "install failed. no webroot found."
	chown jellyfin:jellyfin -R ${D}${INSTALL_DIR}

	einfo "prepare data directory"
	dodir ${DATA_DIR}
	mkdir ${D}${DATA_DIR}/cache
	chown jellyfin:jellyfin -R ${D}${DATA_DIR}
}

pkg_postinst() {
	einfo "jellyfin was installed to ${INSTALL_DIR}, to start please use the init script provided."
	einfo "All data generated and used by Jellyfin can be found at ${DATA_DIR} after the first start."
	einfo ""
}

# UNINSTALL
# #######################################################################################################

pkg_prerm() {
	einfo "Stopping running instances of Jellyfin Server"
	if [ -e "${INIT_SCRIPT}" ]; then
		${INIT_SCRIPT} stop
	fi
}
