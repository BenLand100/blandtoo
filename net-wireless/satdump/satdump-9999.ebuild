# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MyPN="SatDump"
MyP="${MyPN}-master"

inherit cmake

DESCRIPTION="A generic satellite data processing software"
HOMEPAGE="https://www.satdump.org/"
SRC_URI="https://github.com/SatDump/SatDump/archive/refs/heads/master.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse4_1 gles gui opencl openmp tools ziq2 zstd"

# Removed standard satellite decoders (goes, gk2a, meteor, etc.)
# because SatDump bundles them into the 'firstparty_support' plugin automatically.
# Only SDR hardware toggles remain.
SATDUMP_PLUGINS="airspy_sdr bladerf_sdr hackrf_sdr limesdr_sdr mirisdr_sdr net_source_sdr plutosdr_sdr portaudio_sink remote_sdr rfnm_sdr rtaudio_sdr rtaudio_sink rtlsdr_sdr rtltcp sddc_sdr sdrplay_sdr sdrpp_server soapy_sdr spyserver usrp_sdr"

for i in ${SATDUMP_PLUGINS}; do
	IUSE="${IUSE} satdump_plugins_$i"
done

S="${WORKDIR}/${MyP}"

DEPEND="dev-libs/jemalloc:=
	dev-libs/nng:=
	media-libs/libpng:=
	media-libs/tiff:=
	sci-libs/armadillo:=
	sci-libs/fftw:3.0=
	sci-libs/volk:=
	sci-libs/hdf5:=
	gles? (
		>=media-libs/mesa-24.1.0_rc1[opengl]
		<media-libs/mesa-24.1.0_rc1[gles2]
	)
	gui? ( media-libs/glfw:= )
	opencl? ( virtual/opencl )
	ziq2? ( app-arch/zstd:= )
	zstd? ( app-arch/zstd:= )
	satdump_plugins_airspy_sdr? ( net-wireless/airspy:= )
	satdump_plugins_bladerf_sdr? ( net-wireless/bladerf:= )
	satdump_plugins_hackrf_sdr? ( net-libs/libhackrf:= )
	satdump_plugins_limesdr_sdr? ( net-wireless/limesuite:= )
	satdump_plugins_mirisdr_sdr? ( virtual/libusb:1 )
	satdump_plugins_plutosdr_sdr? (
		net-libs/libad9361-iio:=
		net-libs/libiio:=
	)
	satdump_plugins_portaudio_sink? ( media-libs/portaudio:= )
	satdump_plugins_rfnm_sdr? ( virtual/libusb:1 )
	satdump_plugins_rtaudio_sdr? ( media-libs/rtaudio:= )
	satdump_plugins_rtaudio_sink? ( media-libs/rtaudio:= )
	satdump_plugins_rtlsdr_sdr? ( net-wireless/rtl-sdr:= )
	satdump_plugins_sddc_sdr? ( virtual/libusb:1 )
	satdump_plugins_sdrplay_sdr? ( net-wireless/sdrplay:= )
	satdump_plugins_sdrpp_server? ( app-arch/zstd:= )
	satdump_plugins_soapy_sdr? ( net-wireless/soapysdr:= )
	satdump_plugins_usrp_sdr? ( net-wireless/uhd:= )
"
RDEPEND="${DEPEND}"
BDEPEND=""
REQUIRED_USE="gles? ( gui )"

src_prepare() {
	sed -i "s|/lib/satdump/|/$(get_libdir)/satdump/|g" src-core/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# Force static libraries to prevent Gentoo's versioned symlink double-load crash
		-DBUILD_SHARED_LIBS=OFF

		-DBUILD_GLES=$(usex gles ON OFF)
		-DBUILD_GUI=$(usex gui ON OFF)
		-DBUILD_OPENCL=$(usex opencl ON OFF)
		-DBUILD_OPENMP=$(usex openmp ON OFF)
		-DBUILD_TOOLS=$(usex tools ON OFF)
		-DBUILD_ZIQ=$(usex zstd ON OFF)
		-DBUILD_ZIQ2=$(usex ziq2 ON OFF)
		-DPLUGIN_SIMD_NEON=$(usex cpu_flags_arm_neon ON OFF)
		-DPLUGIN_SIMD_SSE41=$(usex cpu_flags_x86_sse4_1 ON OFF)
		
		# Hardware / SDR Sources
		-DPLUGIN_AIRSPY_SDR_SUPPORT=$(usex satdump_plugins_airspy_sdr ON OFF)
		-DPLUGIN_BLADERF_SDR_SUPPORT=$(usex satdump_plugins_bladerf_sdr ON OFF)
		-DPLUGIN_HACKRF_SDR_SUPPORT=$(usex satdump_plugins_hackrf_sdr ON OFF)
		-DPLUGIN_LIMESDR_SDR_SUPPORT=$(usex satdump_plugins_limesdr_sdr ON OFF)
		-DPLUGIN_MIRISDR_SDR_SUPPORT=$(usex satdump_plugins_mirisdr_sdr ON OFF)
		-DPLUGIN_NET_SOURCE_SDR_SUPPORT=$(usex satdump_plugins_net_source_sdr ON OFF)
		-DPLUGIN_PLUTOSDR_SDR_SUPPORT=$(usex satdump_plugins_plutosdr_sdr ON OFF)
		-DPLUGIN_PORTAUDIO_SINK=$(usex satdump_plugins_portaudio_sink ON OFF)
		-DPLUGIN_REMOTE_SDR_SUPPORT=$(usex satdump_plugins_remote_sdr ON OFF)
		-DPLUGIN_RFNM_SDR_SUPPORT=$(usex satdump_plugins_rfnm_sdr ON OFF)
		-DPLUGIN_RTAUDIO_SDR_SUPPORT=$(usex satdump_plugins_rtaudio_sdr ON OFF)
		-DPLUGIN_RTAUDIO_SINK=$(usex satdump_plugins_rtaudio_sink ON OFF)
		-DPLUGIN_RTLSDR_SDR_SUPPORT=$(usex satdump_plugins_rtlsdr_sdr ON OFF)
		-DPLUGIN_RTLTCP_SUPPORT=$(usex satdump_plugins_rtltcp ON OFF)
		-DPLUGIN_SDDC_SDR_SUPPORT=$(usex satdump_plugins_sddc_sdr ON OFF)
		-DPLUGIN_SDRPLAY_SDR_SUPPORT=$(usex satdump_plugins_sdrplay_sdr ON OFF)
		-DPLUGIN_SDRPP_SERVER_SUPPORT=$(usex satdump_plugins_sdrpp_server ON OFF)
		-DPLUGIN_SOAPY_SDR_SUPPORT=$(usex satdump_plugins_soapy_sdr ON OFF)
		-DPLUGIN_SPYSERVER_SUPPORT=$(usex satdump_plugins_spyserver ON OFF)
# Copyright 2024-2025 Gentoo Authors
		-DPLUGIN_USRP_SDR_SUPPORT=$(usex satdump_plugins_usrp_sdr ON OFF)
		
		# Dependencies not packaged
		-DPLUGIN_AARONIA_SDR_SUPPORT=OFF
		-DPLUGIN_AIRSPYHF_SDR_SUPPORT=OFF
		-DPLUGIN_AAUDIO_SINK=OFF
	)
	cmake_src_configure
}
