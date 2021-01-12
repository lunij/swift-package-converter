#!/bin/bash

set -euo pipefail

file=NewRelic_XCFramework_Agent_7.2.1.zip
download_url="https://download.newrelic.com/ios_agent/$file"
framework="NewRelic"
output_dir="Frameworks"
tmp_dir="tmp"

download_newrelic_archive() {
    local path=$tmp_dir/$file

    if [ -f "$path" ]; then
        echo "$path already downloaded"
    else
        echo "Downloading $file ..."
        rm -rf $tmp_dir
        mkdir -p $tmp_dir
        curl $download_url --output $path
    fi
}

extract_archive() {
    echo "Extracting $file ..."
    cd $tmp_dir
    unzip -o -q $file
}

zip_xcframework() {
    echo "Zipping XCFramework ..."
    zip -qrX $framework.zip $framework.xcframework

    cd ..
    mkdir -p $output_dir
    mv $tmp_dir/$framework.zip $output_dir

    local checksum=`swift package compute-checksum $output_dir/$framework.zip`
    echo "// $framework: $checksum" >> Package.swift
}

download_newrelic_archive
extract_archive
zip_xcframework
