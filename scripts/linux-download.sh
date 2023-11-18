#! /bin/bash

set -e
export LANG=C

d0="$(cd "$(dirname $0)" && pwd)"

# default values
obs=27
ubuntu=''
apt=true
flg_qt=1

PLUGIN_CMAKE_OPTIONS=''

while (($# > 0)); do
	case "$1" in
		-o)
			obs="$2"
			shift 2;;
		-u)
			ubuntu="$2"
			shift 2;;
		-a)
			apt='sudo apt'
			shift ;;
		--no-qt)
			flg_qt=0
			shift;;
		--qt)
			flg_qt=1
			shift;;
		*)
			echo "Error: unkown option $1" >&2
			exit 1
	esac
done

if test -z "$ubuntu"; then
	if grep -q 'Ubuntu 22.04' /etc/issue; then
		ubuntu='ubuntu-22.04'
	elif grep -q 'Ubuntu 20.04' /etc/issue; then
		ubuntu='ubuntu-20.04'
	else
		echo "Error: unsupported OS. Set -u option." >&2
		exit 1
	fi
fi

$apt update
$apt install \
	wget \
	cmake ninja-build pkg-config clang clang-format build-essential curl ccache g++ \
	bzip2 \
	file \
	libcmocka-dev

if ((flg_qt)); then
	case "$ubuntu/$obs" in
		ubuntu-20.04/* | */27*)
			$apt install qtbase5-dev qtbase5-private-dev libqt5svg5-dev qtwayland5
			OBS_QT_VERSION_MAJOR=5
			PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS -DQT_VERSION=5"
			;;
		ubuntu-22.04/28* | ubuntu-22.04/30*)
			$apt install qt6-base-dev qt6-base-private-dev libqt6svg6-dev qt6-wayland \
				libxcb1-dev libx11-xcb-dev libwayland-dev \
				libglvnd-dev libgles2-mesa libgles2-mesa-dev
			OBS_QT_VERSION_MAJOR=6
			PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS -DQT_VERSION=6"
			;;
		*)
			echo "Error: Unsupported OS OBS combination $ubuntu/$obs" >&2
			exit 1 ;;
	esac
fi

case "$obs" in
	27 | 27.*)
		curl -o /tmp/obs-studio-devel.deb http://www.nagater.net/obs-studio/obs-studio-27.2.0-771-g89d7653bb-${ubuntu}.deb
		sudo apt install /tmp/obs-studio-devel.deb
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
			-DCMAKE_INSTALL_PREFIX=/usr
			-DCMAKE_INSTALL_LIBDIR=/usr/lib/
			-DLINUX_PORTABLE=OFF
			-DCPACK_DEBIAN_PACKAGE_DEPENDS='obs-studio (>= 27), obs-studio (<< 28)'
			"
		;;
	28 | 28.*)
		case "$ubuntu" in
			ubuntu-20.04)
				curl -O http://www.nagater.net/obs-studio/obs-studio-28.0.0-beta1-11c071ec8-ubuntu-20.04.deb
				sha256sum <<-EOF
4f3bfa7afb90a7e26cf2070ab83a5f2c6630fa52fe18b1201aeb3043ff88a226  obs-studio-28.0.0-beta1-11c071ec8-ubuntu-20.04.deb
EOF
				;;
			ubuntu-22.04)
				curl -O http://www.nagater.net/obs-studio/obs-studio-28.0.0-beta1-11c071ec8-ubuntu-22.04.deb
				sha256sum <<-EOF
52ec56fd40e2d036466f244c707d7ab7d2abc539cc4245d7206cccc022ec84f7  obs-studio-28.0.0-beta1-11c071ec8-ubuntu-22.04.deb
EOF
				;;
		esac
		mv obs-studio-*.deb /tmp/obs-studio-devel.deb
		sudo apt install /tmp/obs-studio-devel.deb
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
			-DCMAKE_INSTALL_PREFIX=/usr
			-DLINUX_PORTABLE=OFF
			-DCPACK_DEBIAN_PACKAGE_DEPENDS='obs-studio (>= 28)'
			"
		;;
	30 | 30.*)
		# copied from https://ppa.launchpadcontent.net/obsproject/obs-studio/ubuntu/pool/main/o/obs-studio/obs-studio_30.0.0-0obsproject1~jammy_amd64.deb
		curl -O http://www.nagater.net/obs-studio/obs-studio_30.0.0-0obsproject1~jammy_amd64.deb
		sha256sum <<<'14ad30bda71195c35e68076e1d53119ba767f424108ed4e42a3331f83676fa00  obs-studio_30.0.0-0obsproject1~jammy_amd64.deb'
		mv obs-studio*.deb /tmp/obs-studio.deb
		sudo apt install /tmp/obs-studio.deb
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
			-DCMAKE_INSTALL_PREFIX=/usr
			-DLINUX_PORTABLE=OFF
			-DCPACK_DEBIAN_PACKAGE_DEPENDS='obs-studio (>= 30)'
			"
		;;
esac

echo "OBS_QT_VERSION_MAJOR=$OBS_QT_VERSION_MAJOR" >> $GITHUB_OUTPUT
echo "PLUGIN_CMAKE_OPTIONS=$(tr '\n' ' ' <<<"$PLUGIN_CMAKE_OPTIONS" | sed -e 's/^ *//' -e 's/ *$//' -e 's/\s\+/ /g')" >> $GITHUB_OUTPUT
