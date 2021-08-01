#!/bin/bash

# Creates dmg image
# Takes arguments:
# $1 - version
# $2 - QRab sources directory path
# $3 - app bundle path

VER=$1
#QRab_SRC=$2
QRab_APP=$3
BUILD=$(git -C $2 rev-list HEAD --count)

hdiutil create -fs HFS+ -srcfolder $QRab_APP/qrab.app -volname "QRab-$VER-b$BUILD" $QRab_APP/QRab-$VER-b$BUILD.dmg



