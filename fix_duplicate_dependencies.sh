#!/bin/bash

echo "🔧 Fixing Duplicate Firebase Dependencies..."

# Navigate to project directory
cd "/Users/aaditprayag/Documents/Prestige3 2/Prestige"

echo "🧹 Cleaning everything..."

# Remove all derived data and caches
rm -rf ~/Library/Developer/Xcode/DerivedData/Prestige-*
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex

# Remove workspace and pods
rm -rf Prestige.xcworkspace
rm -rf Pods Podfile.lock

echo "📦 Reinstalling pods..."

# Reinstall pods
pod install

echo "✅ Dependencies fixed!"
echo ""
echo "📋 Next steps:"
echo "1. Close Xcode completely"
echo "2. Open Prestige.xcworkspace"
echo "3. In Xcode, go to File > Packages > Reset Package Caches"
echo "4. File > Packages > Resolve Package Versions"
echo "5. Product > Clean Build Folder"
echo "6. Build and run: Cmd + R"
echo ""
echo "🔧 If PIF error persists:"
echo "1. In Xcode, go to Project Navigator"
echo "2. Look for any Firebase packages under 'Package Dependencies'"
echo "3. Remove them (right-click > Remove Package)"
echo "4. Clean and build again" 