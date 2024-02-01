#!/bin/bash

if [ ! -f platform.txt ]; then
    echo Launch this script from the root core folder as ./extras/package_sfe.sh
    exit 2
fi

if [ ! -d ../ArduinoCore-API ]; then
    git checkout https://github.com/arduino/ArduinoCore-API.git ../ArduinoCore-API
fi

VERSION=`cat platform.txt | grep "version=" | cut -f2 -d"="`
echo $VERSION

# SparkFun Thing Plus RA6M5

VARIANT=thingplus
EXCLUDE_TAGS="--exclude-tag-all=.unor4_only --exclude-tag-all=.thingplus_exclude"

FILENAME=ArduinoCore-renesas_$VARIANT-$VERSION.tar.bz2

git checkout boards.txt
git checkout platform.txt

sed -i 's/minima./#minima./g' boards.txt
sed -i 's/unor4wifi./#unor4wifi./g' boards.txt
sed -i 's/muxto./#muxto./g' boards.txt
sed -i 's/portenta_c33./#portenta_c33./g' boards.txt
sed -i 's/Arduino Renesas fsp Boards/SparkFun Renesas Thing Plus Boards/g' platform.txt

CORE_BASE=`basename $PWD`
cd ..
tar $EXCLUDE_TAGS --exclude='*.vscode*' --exclude='*.tar.*' --exclude='*.json*' --exclude '*.git*' --exclude='*e2studio*' --exclude='*extras*' -cjhvf $FILENAME $CORE_BASE
cd -

mv ../$FILENAME .

CHKSUM=`sha256sum $FILENAME | awk '{ print $1 }'`
SIZE=`wc -c $FILENAME | awk '{ print $1 }'`

cat extras.package_index.json.tmp |
# sed "s/%%BUILD_NUMBER%%/${BUILD_NUMBER}/" |
# sed "s/%%BUILD_NUMBER%%/${CURR_TIME_SED}/" |
sed "s/%%VERSION%%/${VERSION}/" |
sed "s/%%FILENAME_THINGPLUS%%/${FILENAME}/" |
sed "s/%%CHECKSUM_THINGPLUS%%/${CHKSUM}/" |
sed "s/%%SIZE_THINGPLUS%%/${SIZE}/" > package_renesas_${VERSION}_index.json

