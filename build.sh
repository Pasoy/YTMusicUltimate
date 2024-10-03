#!/bin/bash

set -e 

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

prompt_with_default() {
    local prompt="$1"
    local default="$2"
    read -p "$prompt [$default]: " value
    echo "${value:-$default}"
}

yt_version=$(prompt_with_default "Enter YouTube IPA version" "vX.XX")
tweak_version=$(prompt_with_default "Enter tweak version" "2.2")

read -p "Enter absolute path to IPA file or press Enter to use IPA from current directory: " ipa_path

if [ -z "$ipa_path" ]; then
    ipa_file=$(ls *.ipa 2>/dev/null | head -n 1)
    [ -z "$ipa_file" ] && error_exit "No IPA file found in the current directory."
    ipa_path="$PWD/$ipa_file"
elif [ ! -f "$ipa_path" ]; then
    error_exit "The specified IPA file does not exist."
fi

echo "Using IPA file: $ipa_path"

make clean package SIDELOADING=1 || error_exit "Failed to clean and package."

(
    cd packages || error_exit "Failed to change to packages directory."
    deb_file=$(ls *.deb 2>/dev/null) || error_exit "No .deb file found in packages directory."
    output_ipa="YTMusicUltimate-${yt_version}-${tweak_version}.ipa"
    echo "Using .deb file: $deb_file"
    ~/Azule/azule -i "$ipa_path" -o "$PWD/$output_ipa" -f "$PWD/$deb_file" || error_exit "Azule failed to process the IPA."
    mv "$output_ipa" "${output_ipa%.ipa}.zip" || error_exit "Failed to rename IPA to ZIP."
    unzip -q "${output_ipa%.ipa}.zip" || error_exit "Failed to unzip the file."
    rm -rf Payload/YouTubeMusic.app/Watch || error_exit "Failed to remove Watch directory."
    zip -qr "$output_ipa" Payload || error_exit "Failed to create final IPA."
    rm -rf Payload "${output_ipa%.ipa}.zip" || error_exit "Failed to clean up temporary files."
    echo "Successfully created: $output_ipa"
)