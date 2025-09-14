#!/bin/bash

# Sleep Well App Setup Script

echo "🌙 Setting up Sleep Well Flutter App..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter version
echo "📱 Flutter version:"
flutter --version

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code
echo "🔧 Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check for any issues
echo "🔍 Running analysis..."
flutter analyze

echo "✅ Setup complete!"
echo ""
echo "To run the app:"
echo "  flutter run"
echo ""
echo "To build for production:"
echo "  flutter build apk --release  # Android"
echo "  flutter build ios --release  # iOS"
echo ""
echo "🌙 Sleep Well - Building better sleep habits, one night at a time."
