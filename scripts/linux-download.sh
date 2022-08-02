#! /bin/bash

set -e
export LANG=C

d0="$(cd "$(dirname $0)" && pwd)"

# default values
obs=27
ubuntu=''
apt=true

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
	libx11-dev libxcb-randr0-dev libxcb-shm0-dev libxcb-xinerama0-dev libxcomposite-dev libxinerama-dev \
	libxcb1-dev libx11-xcb-dev libxcb-xfixes0-dev libcmocka-dev libxss-dev libglvnd-dev libgles2-mesa \
	libgles2-mesa-dev libwayland-dev

case "$ubuntu/$obs" in
	ubuntu-20.04/* | */27*)
		$apt install qtbase5-dev qtbase5-private-dev libqt5svg5-dev qtwayland5
		OBS_QT_VERSION_MAJOR=5
		;;
	ubuntu-22.04/28*)
		$apt install qt6-base-dev qt6-base-private-dev libqt6svg6-dev qt6-wayland
		OBS_QT_VERSION_MAJOR=6
		;;
	*)
		echo "Error: Unsupported OS OBS combination $ubuntu/$obs" >&2
		exit 1 ;;
esac

case "$obs" in
	27 | 27.*)
		curl -o /tmp/obs-studio-devel.deb http://www.nagater.net/obs-studio/obs-studio-27.2.0-760-ga4909a667-${ubuntu}.deb
		sudo apt install /tmp/obs-studio-devel.deb
		;;
	28 | 28.*)
		curl -o /tmp/obs-studio-devel.deb http://www.nagater.net/obs-studio/obs-studio-28.0.0-beta1-3b3a4d995-${ubuntu}.deb
		sudo apt install /tmp/obs-studio-devel.deb
		;;
esac

echo "::set-output name=OBS_QT_VERSION_MAJOR::$OBS_QT_VERSION_MAJOR"
