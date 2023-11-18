#! /bin/bash

set -e
export LANG=C

d0="$(cd "$(dirname $0)" && pwd)"

# default values
obs=27
flg_qt=1

PLUGIN_CMAKE_OPTIONS=''

while (($# > 0)); do
	case "$1" in
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

case "$obs" in
	27 | 27.*)
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
	28 | 28.*)
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
	30 | 30.*)
		curl -o obs-plugintemplate.tar.gz --location \
			'http://spr.nagater.net/obs-studio/obs-plugintemplate-b449baf52-windows-x64.tar.gz'
		sha1sum -c <<<'3f32d859b707811b6c6a756bac2de53ef793ac13 obs-plugintemplate.tar.gz'
		tar xzf obs-plugintemplate.tar.gz
		OBS_QT_VERSION_MAJOR=6
		PLUGIN_CMAKE_OPTIONS="$PLUGIN_CMAKE_OPTIONS -DQT_VERSION=6
		-DCMAKE_INSTALL_PREFIX=$PWD/obs-build-dependencies/plugin-deps-x64
		-DCMAKE_PREFIX_PATH=$PWD/obs-build-dependencies/plugin-deps-x64
		"
		;;
	*)
		echo "Error: Unknown OBS version $obs" >&2
		exit 1
esac

PLUGIN_CMAKE_OPTIONS="$(tr '\n' ' ' <<<"$PLUGIN_CMAKE_OPTIONS" | sed -e 's/^ *//' -e 's/ *$//' -e 's/\s\+/ /g')"
PLUGIN_CMAKE_OPTIONS_PS="$(sed -e 's;=/d/;=d:/;g' <<<"$PLUGIN_CMAKE_OPTIONS")"

echo "OBS_QT_VERSION_MAJOR=$OBS_QT_VERSION_MAJOR" >> $GITHUB_OUTPUT
echo "PLUGIN_CMAKE_OPTIONS=$PLUGIN_CMAKE_OPTIONS" >> $GITHUB_OUTPUT
echo "PLUGIN_CMAKE_OPTIONS_PS=$PLUGIN_CMAKE_OPTIONS_PS" >> $GITHUB_OUTPUT
