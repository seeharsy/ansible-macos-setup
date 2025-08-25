#!/bin/bash

# Download script for ansible-macos-setup offline files
# This script downloads all required files for offline installation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/roles/macos_config/files"

echo "Creating files directory..."
mkdir -p "$FILES_DIR"

echo "Downloading files for offline installation..."

# Function to download file with progress
download_file() {
    local url="$1"
    local filename="$2"
    local dest="$FILES_DIR/$filename"
    
    echo "Downloading $filename..."
    if command -v curl >/dev/null 2>&1; then
        curl -L -o "$dest" "$url"
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$dest" "$url"
    else
        echo "Error: Neither curl nor wget found. Please install one of them."
        exit 1
    fi
}

# Download files (add URLs as needed)
# Note: Some files may require manual download due to licensing or availability

echo "Note: Some files require manual download due to licensing restrictions."
echo "Please download the following files manually and place them in $FILES_DIR:"
echo ""
echo "Required files:"
echo "- Xcode_15.4.xip (from Apple Developer Portal)"
echo "- Xcode_16.4.xip (from Apple Developer Portal)"
echo "- LLVM-19.1.7-macOS-ARM64.tar.xz (from LLVM releases)"
echo "- Various .dmg files for applications"
echo ""
echo "For a complete list and download instructions, see the README.md file."

# Download files that are publicly available
if [ -n "$DOWNLOAD_PUBLIC_FILES" ]; then
    echo "Downloading publicly available files..."
    # Add public download URLs here as needed
    # download_file "https://example.com/file.dmg" "file.dmg"
fi

echo ""
echo "Download script completed."
echo "Please ensure all required files are present in $FILES_DIR before running the playbook in offline mode."
