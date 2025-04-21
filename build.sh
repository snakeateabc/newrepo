#!/bin/bash
set -e

# Check if Flutter is already installed
if [ ! -d "flutter" ]; then
    echo "Downloading Flutter..."
    git clone https://github.com/flutter/flutter.git --branch stable
else
    echo "Flutter directory already exists. Using existing installation."
    cd flutter
    git pull origin stable
    cd ..
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify Flutter installation
flutter --version

# Install Flutter dependencies
flutter precache --web

# Enable web
flutter config --enable-web

# Get project dependencies
flutter pub get

# Clean build directory
flutter clean

# Build web app with base-href
flutter build web --release --base-href / 