#!/bin/bash

echo "🔍 Verifying Prestige App Setup..."

# Navigate to project directory
cd "/Users/aaditprayag/Documents/Prestige3 2/Prestige"

echo "📁 Checking required files..."

# Check main app files
if [ -f "Prestige/Prestige/PrestigeApp.swift" ]; then
    echo "✅ Prestige/Prestige/PrestigeApp.swift"
else
    echo "❌ Missing Prestige/Prestige/PrestigeApp.swift"
fi

if [ -f "Prestige/Prestige/LandingPage.swift" ]; then
    echo "✅ Prestige/Prestige/LandingPage.swift"
else
    echo "❌ Missing Prestige/Prestige/LandingPage.swift"
fi

if [ -f "Prestige/Prestige/LoginPage.swift" ]; then
    echo "✅ Prestige/Prestige/LoginPage.swift"
else
    echo "❌ Missing Prestige/Prestige/LoginPage.swift"
fi

if [ -f "Prestige/Prestige/VerificationPage.swift" ]; then
    echo "✅ Prestige/Prestige/VerificationPage.swift"
else
    echo "❌ Missing Prestige/Prestige/VerificationPage.swift"
fi

if [ -f "Prestige/Prestige/HomePage.swift" ]; then
    echo "✅ Prestige/Prestige/HomePage.swift"
else
    echo "❌ Missing Prestige/Prestige/HomePage.swift"
fi

if [ -f "Prestige/Prestige/DashboardView.swift" ]; then
    echo "✅ Prestige/Prestige/DashboardView.swift"
else
    echo "❌ Missing Prestige/Prestige/DashboardView.swift"
fi

if [ -f "Prestige/Prestige/Theme.swift" ]; then
    echo "✅ Prestige/Prestige/Theme.swift"
else
    echo "❌ Missing Prestige/Prestige/Theme.swift"
fi

if [ -f "Prestige/Prestige/SharedComponents.swift" ]; then
    echo "✅ Prestige/Prestige/SharedComponents.swift"
else
    echo "❌ Missing Prestige/Prestige/SharedComponents.swift"
fi

if [ -f "Prestige/Prestige/Backend/FirebaseManager.swift" ]; then
    echo "✅ Prestige/Prestige/Backend/FirebaseManager.swift"
else
    echo "❌ Missing Prestige/Prestige/Backend/FirebaseManager.swift"
fi

echo ""
echo "🔧 Checking iOS compatibility..."

# Check for iOS 16+ Layout protocol usage
if grep -r "Layout" Prestige/Prestige/SharedComponents.swift | grep -q "protocol"; then
    echo "⚠️  Found potential iOS 16+ Layout protocol usage"
else
    echo "✅ No iOS 16+ Layout protocol issues found"
fi

# Check for PhotosUI imports
if grep -r "PhotosUI" Prestige/Prestige/ | grep -q "import"; then
    echo "✅ PhotosUI imports found (iOS 14+ compatible)"
else
    echo "⚠️  No PhotosUI imports found"
fi

echo ""
echo "🔥 Checking Firebase setup..."

# Count Firebase imports
firebase_count=$(grep -r "Firebase" Prestige/Prestige/ | wc -l)
echo "✅ Found $firebase_count Firebase imports"

echo ""
echo "📦 Checking dependencies..."

# Check Podfile
if [ -f "Prestige/Podfile" ]; then
    echo "✅ Podfile exists"
    if grep -q "Firebase" Prestige/Podfile; then
        echo "✅ Firebase dependencies configured"
    else
        echo "❌ Firebase dependencies not found in Podfile"
    fi
else
    echo "❌ Podfile missing"
fi

echo ""
echo "🎉 Setup verification complete!"
echo ""
echo "📋 Next steps:"
echo "1. Open Prestige.xcworkspace in Xcode"
echo "2. Add GoogleService-Info.plist to the project"
echo "3. Build and run the project"
echo ""
echo "📚 For detailed instructions, see README.md"
echo "🔥 For Firebase setup, see FIREBASE_SETUP.md" 