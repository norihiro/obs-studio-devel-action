#! /bin/bash

set -e
export LANG=C

d0="$(cd "$(dirname $0)" && pwd)"

# default values
obs=27
flg_qt=1
arch='x64'

PLUGIN_CMAKE_OPTIONS=''

while (($# > 0)); do
	case "$1" in
		-a)
			arch="$2"
			shift 2;;
		-o)
			obs="$2"
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

if test "$arch" = 'x86_64'; then
	arch='x64'
fi

case "$obs-$arch" in
	27-x64 | 27.*-x64)
		curl -o obs-studio-devel.zip --location \
			'https://github.com/norihiro/obs-plugintemplate/releases/download/27.2.4-nk0-windows/obs-plugintemplate-20221102-ac3d3c9e3-windows-x64.zip'
		sha1sum -c <<<'ea111232d59d7904725c80869510dc35106a38dd obs-studio-devel.zip'
		unzip obs-studio-devel.zip
		OBS_QT_VERSION_MAJOR=5
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
		-DQT_VERSION=5
		-DCMAKE_INSTALL_PREFIX=$PWD/obs-build-dependencies/plugin-deps-x64
		-DCMAKE_PREFIX_PATH=$PWD/obs-build-dependencies/plugin-deps-x64
		"
		;;
	28-x64 | 28.*-x64)
		curl -o obs-studio-devel.zip --location \
			'https://github.com/norihiro/obs-plugintemplate/releases/download/28.0-devel-windows-20220803/obs-plugintemplate-obs-28-04fefe7d6-windows-x64.zip'
		sha1sum -c <<<'4c262a069443f7bdc7e4c64321c028a45340059d obs-studio-devel.zip'
		unzip obs-studio-devel.zip
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS
		-DQT_VERSION=6
		-DCMAKE_INSTALL_PREFIX=$PWD/obs-build-dependencies/plugin-deps-x64
		-DCMAKE_PREFIX_PATH=$PWD/obs-build-dependencies/plugin-deps-x64
		"
		;;
	30-x64 | 30.*-x64)
		curl -o obs-plugintemplate.tar.gz --location \
			'https://github.com/norihiro/obs-plugintemplate/releases/download/30.0.0-dev1/obs-plugintemplate-e0d2ba5da-windows-x64.tar.gz'
		sha1sum -c <<<'8265cc7bf8d95cef0cf2ae502c1069f1b0655ff0 obs-plugintemplate.tar.gz'
		tar xzf obs-plugintemplate.tar.gz
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS -DQT_VERSION=6
		-DCMAKE_INSTALL_PREFIX=$PWD/obs-build-dependencies/plugin-deps-x64
		-DCMAKE_PREFIX_PATH=$PWD/obs-build-dependencies/plugin-deps-x64
		"
		;;
	31-x64 | 31.*-x64)
		curl -o obs-plugintemplate.tar.gz --location \
			'https://github.com/norihiro/obs-plugintemplate/releases/download/31.1.1-dev0/obs-plugintemplate-f6bf43141-windows-x64.tar.gz'
		sha256sum -c <<<'235f9513f98d51b92b160e01938765d5545b3c500c0081dbe74febab5456b8a2 obs-plugintemplate.tar.gz'
		tar xzf obs-plugintemplate.tar.gz
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS -DQT_VERSION=6
		-DCMAKE_INSTALL_PREFIX=$PWD/obs-build-dependencies/plugin-deps-x64
		-DCMAKE_PREFIX_PATH=$PWD/obs-build-dependencies/plugin-deps-x64
		"
		;;
	32-x64 | 32.*-x64)
		curl -o obs-plugintemplate.tar.gz --location \
			'https://github.com/norihiro/obs-plugintemplate/releases/download/32.0.1-dev1/obs-plugintemplate-5b9629713-windows-x64.tar.gz'
		sha256sum -c <<<'65c7769ff5c466cf0d5af4e134669489f21d882c1880ed7b1df6e828e2dbb679 obs-plugintemplate.tar.gz'
		tar xzf obs-plugintemplate.tar.gz
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS -DQT_VERSION=6
		-DCMAKE_INSTALL_PREFIX=$PWD/obs-build-dependencies/plugin-deps-x64
		-DCMAKE_PREFIX_PATH=$PWD/obs-build-dependencies/plugin-deps-x64
		"
		;;
	32-arm64 | 32.*-arm64)
		curl -o obs-plugintemplate.tar.gz --location \
			'https://github.com/norihiro/obs-plugintemplate/releases/download/32.0.1-dev2/obs-plugintemplate-1116ffc69-windows-arm64.tar.gz'
		sha256sum -c <<<'86c2cd2a07542a8e830f2a20154375658a56b68f67326d3f2bc916131b24e7a0 obs-plugintemplate.tar.gz'
		tar xzf obs-plugintemplate.tar.gz
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS -DQT_VERSION=6
		-DCMAKE_INSTALL_PREFIX=$PWD/obs-build-dependencies/plugin-deps-arm64
		-DCMAKE_PREFIX_PATH=$PWD/obs-build-dependencies/plugin-deps-arm64
		"
		;;
	*)
		echo "Error: Unknown pair of OBS version $obs and architecture $arch" >&2
		exit 1
esac

PLUGIN_CMAKE_OPTIONS="$(tr '\n' ' ' <<<"$PLUGIN_CMAKE_OPTIONS" | sed -e 's/^ *//' -e 's/ *$//' -e 's/\s\+/ /g')"
PLUGIN_CMAKE_OPTIONS_PS="$(sed -e 's;=/\([cd]\)/;=\1:/;g' <<<"$PLUGIN_CMAKE_OPTIONS")"

echo "OBS_QT_VERSION_MAJOR=$OBS_QT_VERSION_MAJOR" >> $GITHUB_OUTPUT
echo "PLUGIN_CMAKE_OPTIONS=$PLUGIN_CMAKE_OPTIONS" >> $GITHUB_OUTPUT
echo "PLUGIN_CMAKE_OPTIONS_PS=$PLUGIN_CMAKE_OPTIONS_PS" >> $GITHUB_OUTPUT
