#!/bin/bash

echo "🚀 Setting up Prestige App..."

# Navigate to project directory
cd "/Users/aaditprayag/Documents/Prestige3 2/Prestige"

echo "📦 Installing CocoaPods dependencies..."

# Install pods
pod install

if [ $? -eq 0 ]; then
    echo "✅ Pods installed successfully!"
else
    echo "❌ Pod installation failed!"
    echo "Please check your CocoaPods installation:"
    echo "sudo gem install cocoapods"
    exit 1
fi

echo "🔧 Making scripts executable..."

# Make scripts executable
chmod +x verify_setup.sh
chmod +x build_project.sh
chmod +x fix_duplicate_dependencies.sh

echo "📋 Verifying setup..."

# Run verification
./verify_setup.sh

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📱 Next steps:"
echo "1. Open Prestige.xcworkspace in Xcode"
echo "2. Add GoogleService-Info.plist to the project"
echo "3. Build and run the project"
echo ""
echo "📚 Documentation:"
echo "- README.md - Complete setup guide"
echo "- FIREBASE_SETUP.md - Firebase configuration"
echo "- TROUBLESHOOTING.md - Common issues and solutions"
echo ""
echo "🔧 Available scripts:"
echo "- ./verify_setup.sh - Check project setup"
echo "- ./build_project.sh - Build the project"
echo "- ./fix_duplicate_dependencies.sh - Fix dependency conflicts" 