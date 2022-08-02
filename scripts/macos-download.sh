#! /bin/bash

set -e
export LANG=C

d0="$(cd "$(dirname $0)" && pwd)"

while (($# > 0)); do
	case "$1" in
		-a)
			arch="$2"
			shift 2;;
		-o)
			obs="$2"
			shift 2;;
		-d)
			deps="$2"
			shift 2;;
		*)
			echo "Error: unkown option $1" >&2
			exit 1
	esac
done

brew bundle --file "$d0/Brewfile"

case "$obs-$arch" in
	28-x86_64)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-08-02/macos-deps-2022-08-02-x86_64.tar.xz" \
			7637e52305e6fc53014b5aabd583f1a4490b1d97450420e977cae9a336a29525 \
			$deps
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-08-02/macos-deps-qt6-2022-08-02-x86_64.tar.xz" \
			a83f72a11023b03b6cb2dc365f0a66ad9df31163bbb4fe2df32d601856a9fad3 \
			$deps
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-28.0.0-beta1-11-g53996591f-macos-x86_64.tar.gz \
			6990664762dc81083fe66ab09da50efe5e96351d9db7d82e132dfb48601fa0fd \
			$deps
		MACOSX_DEPLOYMENT_TARGET=10.15
		OBS_QT_VERSION_MAJOR=6
		;;
	28-arm64)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-08-02/macos-deps-2022-08-02-arm64.tar.xz" \
			755e0fa69b17a3ae444e1befa9d91d77e3cafe628fbd1c6333686091826595cd \
			$deps
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-08-02/macos-deps-qt6-2022-08-02-universal.tar.xz" \
			252e6684f43ab9c6f262c73af739e2296ce391b998da2c4ee04c254aaa07db18 \
			$deps
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-28.0.0-beta1-11-g53996591f-macos-arm64.tar.gz \
			d901264b566ba24524967909b89afdae364b1bcf392451eb880a3248fdb6a04c \
			$deps
		MACOSX_DEPLOYMENT_TARGET=11.0
		OBS_QT_VERSION_MAJOR=6
		;;
	27-x86_64)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-07-18/macos-deps-2022-07-18-x86_64.tar.xz" \
			d2fc48e4cbcef840d59d6122f0e78f69602ff8f6264ea9a6fdfcfce88607e98d \
			$deps
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-07-18/macos-deps-qt5-2022-07-18-x86_64.tar.xz" \
			13787c6c21b931373833652d5016dd80634110c2b735eb0bf03b4c77b86a4489 \
			$deps
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-27.2.0-770-g51875d1aa-macos-x86_64.tar.gz \
			057609be298faecbb3a699698c075e4edaa2541e2660ae3436a42bc4600d2a12 \
			$deps
		MACOSX_DEPLOYMENT_TARGET=10.13
		OBS_QT_VERSION_MAJOR=5
		;;
	27-arm64)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-07-18/macos-deps-2022-07-18-arm64.tar.xz" \
			1386418e41a60d83dd7de8742ede3d13ebb27b40ded6e7e41c00fd85a677a09d \
			$deps
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-07-18/macos-deps-qt5-2022-07-18-universal.tar.xz" \
			f8885ba0952740dc3f0d2bf966a05cc181e1dcd17a43bcf14f9a480fd95d65d1 \
			$deps
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-27.2.0-770-g51875d1aa-macos-arm64.tar.gz \
			1b81cf14a627d682448095737b448653380d5f4d0499a1cc135b237bc5c61e35 \
			$deps
		MACOSX_DEPLOYMENT_TARGET=11.0
		OBS_QT_VERSION_MAJOR=5
		;;
	*)
		echo "Error: unknown architecture '$arch' OBS '$obs' combination." >&2
		exit 1
		;;
esac

echo "::set-output name=MACOSX_DEPLOYMENT_TARGET::$MACOSX_DEPLOYMENT_TARGET"
echo "::set-output name=OBS_QT_VERSION_MAJOR::$OBS_QT_VERSION_MAJOR"
