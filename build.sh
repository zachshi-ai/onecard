#!/bin/bash
set -e
BT=/root/android/android-14
AJ=/root/android/android-35/android.jar
NAME=onecard
APP=/root/$NAME/app
OUT=/root/$NAME/out
mkdir -p $OUT
cd $APP

$BT/aapt2 compile --dir res -o $OUT/res.zip
$BT/aapt2 link -o $OUT/base.apk \
  --manifest AndroidManifest.xml \
  -I $AJ -R $OUT/res.zip \
  --min-sdk-version 21 --target-sdk-version 34 --auto-add-overlay

rm -rf $OUT/classes; mkdir -p $OUT/classes
javac -encoding UTF-8 -source 8 -target 8 -bootclasspath $AJ -classpath $AJ \
  -d $OUT/classes java/com/stepx/onecard/*.java

$BT/d8 --lib $AJ --min-api 21 --output $OUT $(find $OUT/classes -name '*.class')

cd $OUT
cp base.apk unsigned.apk
rm -rf pkg; mkdir -p pkg/assets
cp classes.dex pkg/
cp -r $APP/assets/. pkg/assets/
cd pkg && zip -q -r ../unsigned.apk classes.dex assets && cd ..

$BT/zipalign -p -f 4 unsigned.apk aligned.apk
$BT/apksigner sign --ks $APP/debug.keystore --ks-pass pass:android \
  --key-pass pass:android --out /root/$NAME/onecard.apk aligned.apk
echo "=== BUILD OK ==="
ls -la /root/$NAME/onecard.apk
$BT/aapt2 dump badging /root/$NAME/onecard.apk | head -4
