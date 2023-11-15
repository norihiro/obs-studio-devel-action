#! /bin/bash

set -e
export LANG=C

d0="$(cd "$(dirname $0)" && pwd)"

# default values
obs=27
flg_qt=1

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
		OBS_QT_VERSION_MAJOR=5
		;;
	28 | 28.*)
		curl -o obs-studio-devel.zip --location \
			'https://github.com/norihiro/obs-plugintemplate/releases/download/28.0-devel-windows-20220803/obs-plugintemplate-obs-28-04fefe7d6-windows-x64.zip'
		sha1sum -c <<<'4c262a069443f7bdc7e4c64321c028a45340059d obs-studio-devel.zip'
		OBS_QT_VERSION_MAJOR=6
		;;
	*)
		echo "Error: Unknown OBS version $obs" >&2
		exit 1
esac

unzip obs-studio-devel.zip

echo "OBS_QT_VERSION_MAJOR=$OBS_QT_VERSION_MAJOR" >> $GITHUB_OUTPUT
