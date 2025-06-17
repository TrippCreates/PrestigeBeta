#!/bin/bash

echo "🔧 Removing Swift Package Manager Firebase dependencies..."

# Navigate to project directory
cd "/Users/aaditprayag/Documents/Prestige3 2/Prestige"

echo "📦 Reinstalling pods only..."

# Clean and reinstall pods
rm -rf Pods Podfile.lock
pod install

echo "✅ Swift Package Manager dependencies removed!"
echo ""
echo "📋 Next steps:"
echo "1. Close Xcode completely"
echo "2. Open Prestige.xcworkspace"
echo "3. Clean build folder: Product > Clean Build Folder"
echo "4. Build and run: Cmd + R"
echo ""
echo "🔧 If you still see PIF errors:"
echo "1. In Xcode, go to File > Packages > Reset Package Caches"
echo "2. File > Packages > Resolve Package Versions"
echo "3. Product > Clean Build Folder"
echo "4. Try building again" 