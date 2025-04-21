#!/bin/bash
set -e

# Download Flutter
git clone https://github.com/flutter/flutter.git --branch stable
export PATH="$PATH:`pwd`/flutter/bin"

# Install Flutter dependencies
flutter precache
flutter doctor -v

# Get project dependencies
flutter pub get

# Build web app
flutter build web 