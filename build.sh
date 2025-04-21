#!/bin/bash
set -e

# Download Flutter
git clone https://github.com/flutter/flutter.git --branch stable
export PATH="$PATH:`pwd`/flutter/bin"

# Install Flutter dependencies
flutter precache --web

# Enable web
flutter config --enable-web

# Get project dependencies
flutter pub get

# Build web app
flutter build web --release 