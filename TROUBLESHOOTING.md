# 🔧 Troubleshooting Guide

## PIF (Package Index Format) Error

### Problem
```
Build service could not create build operation: unable to load transferred PIF: 
The workspace contains multiple references with the same GUID 'PACKAGE:1OCNX1B0IBW730SAWD8921NUF9AT29PXR::MAINGROUP'
```

### Root Cause 🔍
This error occurs because your project has **both Swift Package Manager Firebase dependencies AND CocoaPods Firebase dependencies**, causing conflicts in the Package Index Format.

### Solution ✅ (Manual Fix Required)

**Step 1: Remove Swift Package Manager Dependencies**
1. Close Xcode completely
2. Open `Prestige.xcworkspace` (NOT .xcodeproj)
3. In **Project Navigator**, look for **"Package Dependencies"** section
4. **Right-click on each Firebase package** and select **"Remove Package"**
5. Remove ALL Firebase packages:
   - Firebase
   - FirebaseAnalytics
   - FirebaseAuth
   - FirebaseCore
   - FirebaseFirestore
   - FirebaseStorage
   - FirebaseMessaging

**Step 2: Clean Package Caches**
1. **File > Packages > Reset Package Caches**
2. **File > Packages > Resolve Package Versions**

**Step 3: Clean Build**
1. **Product > Clean Build Folder**
2. Close Xcode completely
3. Reopen `Prestige.xcworkspace`

**Step 4: Build and Test**
1. Select target device/simulator
2. Press **Cmd + R** to build and run

### Alternative: Complete Reset
```bash
./fix_duplicate_dependencies.sh
```

### Verification ✅
After fixing, you should see:
- ✅ No Firebase packages in "Package Dependencies"
- ✅ Only CocoaPods dependencies in "Pods" section
- ✅ Clean build without PIF errors

### Why This Happens
- **Swift Package Manager**: Firebase packages added via Xcode's package manager
- **CocoaPods**: Firebase packages added via Podfile
- **Conflict**: Same dependencies managed by multiple systems creates duplicate GUIDs

### Prevention
- ✅ Use **only CocoaPods** for Firebase dependencies
- ❌ Don't add Firebase packages via Swift Package Manager
- ✅ Always open `.xcworkspace` when using CocoaPods

## Framework Conflicts (Multiple Commands Produce...)

### Problem
```
Multiple commands produce '/Users/.../Prestige.app/Frameworks/absl.framework'
Multiple commands produce '/Users/.../Prestige.app/Frameworks/openssl_grpc.framework'
Multiple commands produce '/Users/.../Prestige.app/Frameworks/grpcpp.framework'
```

### Solution ✅ (Already Applied)
1. **Updated Podfile** with post_install hooks
2. **Cleaned and reinstalled** dependencies
3. **Cleared derived data**

### If Problem Persists

#### Option 1: Manual Clean Build
```bash
# 1. Clean everything
rm -rf Pods Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData/Prestige-*

# 2. Reinstall pods
pod install

# 3. Open workspace in Xcode
open Prestige.xcworkspace

# 4. Clean build folder in Xcode
# Product > Clean Build Folder
```

#### Option 2: Alternative Podfile Configuration
If the issue persists, try this alternative Podfile:

```ruby
platform :ios, '15.0'

target 'Prestige' do
  use_frameworks!
  
  # Use static frameworks to avoid conflicts
  pod 'Firebase/Core', :modular_headers => true
  pod 'Firebase/Auth', :modular_headers => true
  pod 'Firebase/Firestore', :modular_headers => true
  pod 'Firebase/Storage', :modular_headers => true
  pod 'Firebase/Messaging', :modular_headers => true
  pod 'Firebase/Analytics', :modular_headers => true
  
  target 'PrestigeTests' do
    inherit! :search_paths
  end

  target 'PrestigeUITests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
```

## Common Build Issues

### 1. "Firebase not configured" Error
**Solution:**
- Ensure `GoogleService-Info.plist` is added to the project
- Verify bundle ID matches Firebase project
- Check that Firebase is initialized in `PrestigeApp.swift`

### 2. "No such module 'Firebase'" Error
**Solution:**
```bash
# Clean and reinstall
rm -rf Pods Podfile.lock
pod install
# Open Prestige.xcworkspace (NOT .xcodeproj)
```

### 3. Simulator Build Issues
**Solution:**
- Use iPhone 15+ simulator
- Clean build folder: `Product > Clean Build Folder`
- Reset package caches: `File > Packages > Reset Package Caches`

### 4. Signing Issues
**Solution:**
- Configure Apple Developer account in Xcode
- Update bundle identifier if needed
- Check provisioning profiles

## Build Process

### ✅ Recommended Build Steps
1. **Open Workspace**: `open Prestige.xcworkspace`
2. **Select Target**: iPhone 15+ simulator
3. **Clean Build**: `Product > Clean Build Folder`
4. **Build & Run**: `Cmd + R`

### 🔧 If Build Fails
1. **Check Console**: Look for specific error messages
2. **Clean Everything**: 
   ```bash
   rm -rf Pods Podfile.lock
   pod install
   ```
3. **Reset Xcode**: Close Xcode, reopen workspace
4. **Update Xcode**: Ensure you're using Xcode 14+

## Verification Commands

### Check Setup
```bash
./verify_setup.sh
```

### Check Dependencies
```bash
pod install --verbose
```

### Clean Derived Data
```bash
sudo rm -rf ~/Library/Developer/Xcode/DerivedData/Prestige-*
```

### Fix PIF Error
```bash
./fix_duplicate_dependencies.sh
```

## Firebase Setup Issues

### Missing GoogleService-Info.plist
1. Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add iOS app with your bundle ID
3. Download `GoogleService-Info.plist`
4. Add to Xcode project (drag and drop)

### Firebase Services Not Working
1. Enable required services in Firebase Console:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage
   - Messaging
2. Check security rules
3. Verify bundle ID matches

## Still Having Issues?

### 1. Check Xcode Version
- Minimum: Xcode 14.0
- Recommended: Xcode 15.0+

### 2. Check iOS Target
- Minimum: iOS 15.0
- Recommended: iOS 16.0+

### 3. Check CocoaPods Version
```bash
pod --version
# Should be 1.12.0 or higher
```

### 4. Alternative: Swift Package Manager
If CocoaPods continues to cause issues, consider migrating to Swift Package Manager:

1. Remove Podfile and Pods directory
2. Add Firebase packages via Xcode: `File > Add Package Dependencies`
3. Search for Firebase packages and add them

## Support

If you're still experiencing issues:
1. Check the error messages in Xcode console
2. Verify all files are present using `./verify_setup.sh`
3. Ensure you're following the Firebase setup guide
4. Try building on a different simulator or device

**Remember**: Always open `Prestige.xcworkspace`, never `Prestige.xcodeproj` when using CocoaPods! 