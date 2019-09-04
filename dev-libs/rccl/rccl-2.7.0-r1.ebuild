# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rccl/archive/${PV}.tar.gz -> rccl-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="=sys-devel/hip-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake
	dev-util/rocm-cmake"

IUSE="+gfx803 gfx900 gfx906 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

S="${WORKDIR}/rccl-${PV}"

PATCHES=(
	"${FILESDIR}/rccl-2.7.0-change_install_location.patch"
)

src_configure() {
	CMAKE_MAKEFILE_GENERATOR=emake
	CXX="/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc"

	if use gfx803; then
		CurrentISA="803"
	fi
	if use gfx900; then
		CurrentISA="900"
	fi
	if use gfx906; then
		CurrentISA="906"
	fi

	local mycmakeargs=(
		-DCMAKE_CXX_FLAGS="--amdgpu-target=gfx${CurrentISA}"
	)

	cmake-utils_src_configure
}
