#! /bin/bash

set -e
export LANG=C

d0="$(cd "$(dirname $0)" && pwd)"

flg_qt=1

PLUGIN_CMAKE_OPTIONS=''

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

brew bundle --file "$d0/Brewfile"

case "$obs-$arch" in
	31-x86_64 | 31-arm64 | 31-universal)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2024-09-12/macos-deps-2024-09-12-universal.tar.xz" \
			c857b211ee378772994b632036e1e5befe66b37e85286cb8e3cefc1435d5220a \
			$deps
		test $flg_qt -gt 0 && $d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2024-09-12/macos-deps-qt6-2024-09-12-universal.tar.xz" \
			34a2de6b7f4d4d58fc5a15a4dba49a61d81a4045d0cedfc1a1f08c0dfb8047cf \
			$deps
		obsdir=/Users/runner/work/obs-studio/obs-studio
		mkdir -p $obsdir
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-29.1.0-1924-g3c78be27f-macos-macos-universal.tar.gz \
			d6ce19945667cfdf730b73e760081b3bda97ed1febeafd9f859f570287c8ef3a \
			$obsdir
		MACOSX_DEPLOYMENT_TARGET=11.0
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
		-DMACOSX_PLUGIN_BUNDLE_TYPE=BNDL
		-DCMAKE_FRAMEWORK_PATH='$obsdir/build_macos;$obsdir/build_macos/UI/obs-frontend-api;$deps/Frameworks;$deps/lib/cmake;$deps'
		"
		;;
	30-x86_64 | 30-arm64 | 30-universal)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2023-11-03/macos-deps-2023-11-03-universal.tar.xz" \
			90c2fc069847ec2768dcc867c1c63b112c615ed845a907dc44acab7a97181974 \
			$deps
		test $flg_qt -gt 0 && $d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2023-11-03/macos-deps-qt6-2023-11-03-universal.tar.xz" \
			ba4a7152848da0053f63427a2a2cb0a199af3992997c0db08564df6f48c9db98 \
			$deps
		obsdir=/Users/runner/work/obs-studio/obs-studio
		mkdir -p $obsdir
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-29.1.0-799-g35bb15f14-macos-macos-universal.tar.gz \
			696490cdf9de55b489bf0bc1715d77327c775b4a62582a233008b6539f7d23af \
			$obsdir
		if test "$arch" == x86_64; then
			MACOSX_DEPLOYMENT_TARGET=10.15
		else
			MACOSX_DEPLOYMENT_TARGET=11.0
		fi
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
		-DMACOSX_PLUGIN_BUNDLE_TYPE=BNDL
		-DCMAKE_FRAMEWORK_PATH='$obsdir/build_macos;$obsdir/build_macos/UI/obs-frontend-api;$deps/Frameworks;$deps/lib/cmake;$deps'
		"
		;;
	28-x86_64)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-08-02/macos-deps-2022-08-02-x86_64.tar.xz" \
			7637e52305e6fc53014b5aabd583f1a4490b1d97450420e977cae9a336a29525 \
			$deps
		test $flg_qt -gt 0 && $d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-08-02/macos-deps-qt6-2022-08-02-x86_64.tar.xz" \
			a83f72a11023b03b6cb2dc365f0a66ad9df31163bbb4fe2df32d601856a9fad3 \
			$deps
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-28.0.0-beta1-202-g11c071ec8-macos-x86_64.tar.gz \
			e8bc3c993b517c37da8bbf86d871613b2e9d75a0aba547d06ee67338d2074488 \
			$deps
		MACOSX_DEPLOYMENT_TARGET=10.15
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
		-DMACOSX_PLUGIN_BUNDLE_TYPE=BNDL
		-DCMAKE_FRAMEWORK_PATH='$deps/Frameworks;$deps/lib/cmake;$deps'
		"
		;;
	28-arm64 | 28-universal)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-08-02/macos-deps-2022-08-02-universal.tar.xz" \
			de057e73e6fe0825664c258ca2dd6798c41ae580bf4d896e1647676a4941934a \
			$deps
		test $flg_qt -gt 0 && $d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-08-02/macos-deps-qt6-2022-08-02-universal.tar.xz" \
			252e6684f43ab9c6f262c73af739e2296ce391b998da2c4ee04c254aaa07db18 \
			$deps
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-28.0.0-beta1-202-g11c071ec8-macos-universal.tar.gz \
			212d5aac7f7ac7a8f06d1892d57f8956514e016cd98579dc4c77eea848269386 \
			$deps
		MACOSX_DEPLOYMENT_TARGET=11.0
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
		-DMACOSX_PLUGIN_BUNDLE_TYPE=BNDL
		-DCMAKE_FRAMEWORK_PATH='$deps/Frameworks;$deps/lib/cmake;$deps'
		"
		;;
	27-x86_64)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-07-18/macos-deps-2022-07-18-x86_64.tar.xz" \
			d2fc48e4cbcef840d59d6122f0e78f69602ff8f6264ea9a6fdfcfce88607e98d \
			$deps
		test $flg_qt -gt 0 && $d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-07-18/macos-deps-qt5-2022-07-18-x86_64.tar.xz" \
			13787c6c21b931373833652d5016dd80634110c2b735eb0bf03b4c77b86a4489 \
			$deps
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-27.2.0-770-g51875d1aa-macos-x86_64.tar.gz \
			057609be298faecbb3a699698c075e4edaa2541e2660ae3436a42bc4600d2a12 \
			$deps
		MACOSX_DEPLOYMENT_TARGET=10.13
		OBS_QT_VERSION_MAJOR=5
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
		-DCMAKE_FRAMEWORK_PATH='$deps/Frameworks;$deps/lib/cmake;$deps'
		"
		;;
	27-arm64)
		$d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-07-18/macos-deps-2022-07-18-universal.tar.xz" \
			e179e79e0742beac5bb4702572f93a47debc600e17916d4ca431b6d23cdb88b9 \
			$deps
		test $flg_qt -gt 0 && $d0/download-extract.sh \
			"https://github.com/obsproject/obs-deps/releases/download/2022-07-18/macos-deps-qt5-2022-07-18-universal.tar.xz" \
			f8885ba0952740dc3f0d2bf966a05cc181e1dcd17a43bcf14f9a480fd95d65d1 \
			$deps
		$d0/download-extract.sh \
			http://www.nagater.net/obs-studio/obs-studio-devel-27.2.0-770-g51875d1aa-macos-arm64.tar.gz \
			1b81cf14a627d682448095737b448653380d5f4d0499a1cc135b237bc5c61e35 \
			$deps
		MACOSX_DEPLOYMENT_TARGET=11.0
		OBS_QT_VERSION_MAJOR=5
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
		-DCMAKE_FRAMEWORK_PATH='$deps/Frameworks;$deps/lib/cmake;$deps'
		"
		;;
	*)
		echo "Error: unknown architecture '$arch' OBS '$obs' combination." >&2
		exit 1
		;;
esac

if ((flg_qt)); then
	PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS -DQT_VERSION=$OBS_QT_VERSION_MAJOR"
fi

PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
-DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}
"

echo "MACOSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET" >> $GITHUB_OUTPUT
echo "OBS_QT_VERSION_MAJOR=$OBS_QT_VERSION_MAJOR" >> $GITHUB_OUTPUT
echo "PLUGIN_CMAKE_OPTIONS=$(tr '\n' ' ' <<<"$PLUGIN_CMAKE_OPTIONS" | sed -e 's/^ *//' -e 's/ *$//' -e 's/\s\+/ /g')" >> $GITHUB_OUTPUT
