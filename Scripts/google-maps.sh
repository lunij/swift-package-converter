#!/bin/bash

set -euo pipefail

file="GoogleMaps-4.1.0.tar.gz"
download_url="https://dl.google.com/dl/cpdc/ea79acddddcfc5ac/$file"
frameworks=("GoogleMaps" "GoogleMapsCore" "GoogleMapsBase" "GoogleMapsM4B")
framework_paths=("Maps/Frameworks" "Maps/Frameworks" "Base/Frameworks" "M4B/Frameworks")
output_dir="Frameworks"
tmp_dir="tmp"

download_google_maps_archive() {
    local path=$tmp_dir/$file

    if [ -f "$path" ]; then
        echo "$file already downloaded"
    else
        echo "Downloading $file ..."
        rm -rf $path
        mkdir -p $tmp_dir
        curl $download_url --output $path
    fi
}

extract_archive() {
    echo "Extracting $file ..."
    cd $tmp_dir
    tar -xzf $file
}

extract_architectures() {
    local archs=`lipo -info $framework_path/$framework | sed -e "s/^.*are: //"`

    rm -rf $framework.framework
    cp -R $framework_path $framework.framework

    for arch in $archs
    do
        local output="$framework.$arch"
        echo "Extracting architecture $arch to $output ..."
        lipo $framework_path/$framework -thin $arch -output $output
    done
}

create_frameworks() {
    local arm_bins=$(find . -type f | egrep ".*\/$framework.(arm64|armv7)")
    local simulator_bins=$(find . -type f | egrep ".*\/$framework.x86_64")

    echo "Creating frameworks ..."
    echo $arm_bins
    echo $simulator_bins

    rm -rf arm
    rm -rf simulator

    mkdir -p arm
    mkdir -p simulator

    cp -R $framework.framework arm/$framework.framework
    cp -R $framework.framework simulator/$framework.framework

    lipo $arm_bins -create -output arm/$framework.framework/$framework
    lipo $simulator_bins -create -output simulator/$framework.framework/$framework
}

create_xcframework() {
    echo "Creating XCFramework ..."
    rm -rf ../$output_dir/$framework.xcframework
    xcodebuild \
        -create-xcframework \
        -framework arm/$framework.framework \
        -framework simulator/$framework.framework \
        -output ../$output_dir/$framework.xcframework
}

zip_xcframework() {
    echo "Zipping XCFramework ..."
    cd ../$output_dir
    zip -qrX $framework.zip $framework.xcframework
    local checksum=`swift package compute-checksum $framework.zip`
    echo "// $framework: $checksum" >> ../Package.swift
    cd ../$tmp_dir
}

download_google_maps_archive
extract_archive

for index in "${!frameworks[@]}"
do
    framework=${frameworks[$index]}
    framework_path="${framework_paths[$index]}/$framework.framework"

    extract_architectures
    create_frameworks
    create_xcframework
    zip_xcframework
done
