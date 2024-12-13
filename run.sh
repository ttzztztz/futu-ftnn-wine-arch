#!/bin/sh

version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }

PKG_NAME="__PKG_NAME__"
PKG_VER="__PKG_VER__"
BASEDIR="$HOME/.ftnn"
WINEPREFIX="$BASEDIR/wine"
FONTS_PATH="$WINEPREFIX/drive_c/windows/Fonts"
EXEC_PATH="c:/Program Files (x86)/FTNN/FTNN.exe"
EXEC_FILE="$WINEPREFIX/drive_c/Program Files (x86)/FTNN/FTNN.exe"
INSTALLER_PATH="/usr/share/$PKG_NAME/FTNN_INSTALLER_$PKG_VER.exe"
export MIME_TYPE=""
export APPRUN_CMD="wine"
DISABLE_ATTACH_FILE_DIALOG=""

OpenWinecfg()
{
    env WINEPREFIX=$WINEPREFIX $APPRUN_CMD winecfg
}

DeployApp()
{
    # backup fonts
    if [ -d "$FONTS_PATH" ];then
        mkdir -p $BASEDIR/tmp/font_backup
        cp $FONTS_PATH/* $BASEDIR/tmp/font_backup/
    fi

    # re-deploy bottle
    rm -rf "$WINEPREFIX"
    mkdir -p "$WINEPREFIX"

    # resolve CJK issue
    ln -sf "/usr/share/fonts/wenquanyi/wqy-microhei/wqy-microhei.ttc" "$FONTS_PATH/wqy-microhei.ttc"
    env WINEPREFIX=$WINEPREFIX $APPRUN_CMD start regedit.exe /usr/share/com.futu.ftnn.wine/cjk-font.reg

    # run installer
    env WINEPREFIX=$WINEPREFIX $APPRUN_CMD "$INSTALLER_PATH" "$@"

    # restore fonts
    if [ -d "$BASEDIR/tmp/font_backup" ];then
        cp -n $BASEDIR/tmp/font_backup/* $FONTS_PATH/
        rm -rf "$BASEDIR/tmp/font_backup"
    fi

    touch $WINEPREFIX/reinstalled
    cat $BASEDIR/files/files.md5sum > $WINEPREFIX/PACKAGE_VERSION
}

Run()
{
    if [ -z "$DISABLE_ATTACH_FILE_DIALOG" ];then
        export ATTACH_FILE_DIALOG=1
    fi

    if [ -n "$EXEC_PATH" ];then
        if [ ! -f "$WINEPREFIX/reinstalled" ];then
            DeployApp
        else
            # missing exec file
            if [ ! -f "$EXEC_FILE" ];then
                DeployApp
            fi

            env WINEPREFIX=$WINEPREFIX $APPRUN_CMD "$EXEC_PATH" "$@"
        fi
    else
        env WINEPREFIX=$WINEPREFIX $APPRUN_CMD "UnInstall.exe" "$@"
    fi
}

HelpApp()
{
	echo " Extra Commands:"
	echo " winecfg        Open winecfg"
	echo " -h/--help      Show program help info"
}

if [ -z $1 ]; then
	Run "$@"
	exit 0
fi
case $1 in
	"winecfg")
		OpenWinecfg
		;;
	"-h" | "--help")
		HelpApp
		;;
	*)
		Run "$@"
		;;
esac
exit 0
