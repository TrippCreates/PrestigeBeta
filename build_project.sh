#!/bin/bash

echo "🚀 Building Prestige App..."

# Navigate to project directory
cd "/Users/aaditprayag/Documents/Prestige3 2/Prestige"

echo "📦 Checking dependencies..."

# Check if pods are installed
if [ ! -d "Pods" ]; then
    echo "📦 Installing pods..."
    pod install
else
    echo "✅ Pods already installed"
fi

echo "🧹 Cleaning build..."

# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/Prestige-*

echo "🔨 Building project..."

# Build the project
xcodebuild -workspace Prestige.xcworkspace \
           -scheme Prestige \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           -configuration Debug \
           build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📱 Next steps:"
    echo "1. Open Prestige.xcworkspace in Xcode"
    echo "2. Select iPhone 15+ simulator"
    echo "3. Press Cmd + R to run"
    echo ""
    echo "🔧 If you encounter issues:"
    echo "1. Check TROUBLESHOOTING.md"
    echo "2. Run ./verify_setup.sh"
    echo "3. Ensure GoogleService-Info.plist is added"
else
    echo "❌ Build failed!"
    echo ""
    echo "🔧 Troubleshooting:"
    echo "1. Check error messages above"
    echo "2. Run ./verify_setup.sh"
    echo "3. Check TROUBLESHOOTING.md"
    echo "4. Ensure you're using Prestige.xcworkspace"
fi 