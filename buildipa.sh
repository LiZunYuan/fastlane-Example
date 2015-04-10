#!/bin/sh

echo go to `dirname $0`
cd `dirname $0`
echo `pwd`

xcodebuild clean -configuration Distribution

appName="MISpring"
curDir=`pwd`
distDir="$curDir/buildipa"
codeIdentify="\"iPhone Distribution: Husor Inc.\""

if [ -d $distDir ];then
    rm -rf "$distDir"
    mkdir $distDir
else
    mkdir $distDir
fi

releaseDir="build/Release-iphoneos"
channel="$curDir/channelId.dat"

rm -rdf "$releaseDir"

xcodebuild -target $appName -configuration Distribution -sdk iphoneos build  CODE_SIGN_IDENTITY="iPhone Distribution: Husor Inc."
echo "xcode build completed-----------------"
# GCC_PREPROCESSOR_DEFINITIONS="API_TYPE=$i"

cp -R "$releaseDir/$appName.app" "$distDir/$appName.app"

cd "$distDir/$appName.app"

while read channelId
do
echo $channelId > channelId.data

/usr/bin/xcrun -sdk iphoneos PackageApplication -v "$distDir/$appName.app" -o "$distDir/$channelId.ipa" —sign "iPhone Distribution: Husor Inc."
done < $channel

