# Comprehensive Firebase Framework Conflict Solution

## Problem Summary
You're experiencing multiple issues:
1. **Multiple commands produce** errors for frameworks (absl, grpcpp, openssl_grpc, etc.)
2. **Duplicate output file** errors for Firebase frameworks
3. **Deployment target warnings** (pods targeting iOS 9.0-11.0 while project targets iOS 15+)
4. **Source code processing errors** for .inc files
5. **Duplicate resource files** (LICENSE, README.md, PrivacyInfo.xcprivacy)

## Root Cause
- **Mixed dependency management**: Both Swift Package Manager (SPM) and CocoaPods have Firebase dependencies
- **Outdated deployment targets**: Pods are configured for older iOS versions
- **Duplicate framework embedding**: Same frameworks being embedded multiple times
- **Build configuration conflicts**: Inconsistent build settings across targets

## Automated Fix Script

Run this comprehensive fix script:

```bash
#!/bin/bash

echo "🚀 Starting Comprehensive Firebase Framework Conflict Fix..."

# Clean everything
rm -rf ~/Library/Developer/Xcode/DerivedData/*
pod cache clean --all
rm -rf Pods/
rm -rf Podfile.lock

# Create updated Podfile
cat > Podfile << 'EOF'
platform :ios, '15.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Prestige.xcodeproj'

pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Storage'
pod 'Firebase/Messaging'
pod 'Firebase/Analytics'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['SKIP_INSTALL'] = 'NO'
      config.build_settings['MACH_O_TYPE'] = 'staticlib'
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
      config.build_settings['COPY_PHASE_STRIP'] = 'NO'
    end
  end
  
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
EOF

# Install pods
pod install --repo-update

# Clean build
xcodebuild clean -workspace Prestige.xcworkspace -scheme Prestige

echo "✅ Automated fixes completed!"
echo "📋 Next: Follow manual steps in Xcode"
EOF
```

## Manual Xcode Fixes

### Step 1: Remove Swift Package Manager Firebase Dependencies

**CRITICAL**: You must remove ALL Firebase packages from Swift Package Manager.

1. Open `Prestige.xcworkspace` (NOT .xcodeproj)
2. Go to **File > Add Package Dependencies**
3. Look for any Firebase packages in the list
4. **Remove ALL Firebase packages** from SPM
5. Keep only CocoaPods Firebase dependencies

### Step 2: Fix Project Build Settings

1. Select the **Prestige** project in the navigator
2. Select the **Prestige** target
3. Go to **Build Settings** tab
4. Update these settings:

| Setting | Value |
|---------|-------|
| iOS Deployment Target | `15.0` |
| Enable Bitcode | `No` |
| CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER | `No` |
| BUILD_LIBRARY_FOR_DISTRIBUTION | `Yes` |

### Step 3: Fix Framework Embedding (CRITICAL)

1. Select the **Prestige** target
2. Go to **Build Phases** tab
3. Expand **Embed Frameworks**
4. **Remove ALL duplicate entries** of these frameworks:
   - `absl.framework`
   - `grpcpp.framework`
   - `openssl_grpc.framework`
   - `FirebaseFirestoreInternal.framework`
   - `grpc.framework`
   - `FirebaseAnalytics.framework`
   - `GoogleAdsOnDeviceConversion.framework`
   - `GoogleAppMeasurement.framework`

5. Ensure each framework appears **only once**
6. Set all frameworks to **Embed & Sign**

### Step 4: Fix Pod Target Build Settings

1. In the project navigator, expand **Pods**
2. Select **Pods** project
3. For each target, update build settings:

**Targets to fix:**
- `abseil`
- `BoringSSL-GRPC`
- `FirebaseCore`
- `FirebaseAuth`
- `FirebaseFirestore`
- `FirebaseStorage`
- `FirebaseMessaging`
- `FirebaseAnalytics`
- `gRPC-C++`
- `gRPC-Core`
- `leveldb-library`
- `PromisesObjC`
- `RecaptchaInterop`

**Settings for each target:**
- **iOS Deployment Target**: `15.0`
- **Enable Bitcode**: `No`
- **CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER**: `No`

### Step 5: Remove Duplicate Resources

1. Go to **Build Phases > Copy Bundle Resources**
2. Remove duplicate entries for:
   - `LICENSE` files
   - `README.md` files
   - `PrivacyInfo.xcprivacy` files
   - `GoogleService-Info.plist` (keep only one)

### Step 6: Clean and Build

1. **Product > Clean Build Folder**
2. **Product > Build**

## Troubleshooting Specific Errors

### "Multiple commands produce" Error
**Solution**: Remove duplicate framework entries in Build Phases > Embed Frameworks

### Deployment Target Warnings
**Solution**: Update all pod targets to iOS 15.0 minimum

### Duplicate Output File Errors
**Solution**: Remove duplicate resource files from Copy Bundle Resources

### Source Code Processing Errors (.inc files)
**Solution**: These are usually harmless include files, can be ignored

### Duplicate Framework Embedding
**Solution**: Ensure each framework appears only once in Embed Frameworks

## Verification Steps

After applying all fixes:

1. **Clean Build Folder** (Product > Clean Build Folder)
2. **Build for iOS Simulator**
3. **Build for iOS Device**
4. Check that no framework conflicts appear
5. Verify app launches successfully

## If Problems Persist

### Complete Reset
```bash
rm -rf Pods/
rm -rf ~/Library/Developer/Xcode/DerivedData/*
pod cache clean --all
pod install
```

### Check for SPM Conflicts
- Ensure no Firebase packages in Package Dependencies
- Remove any Firebase SPM references

### Verify Podfile
- Ensure `platform :ios, '15.0'`
- Ensure post_install hook is present
- Ensure all Firebase pods are listed

## Final Notes

- **Always use .xcworkspace** for CocoaPods projects
- **Never mix SPM and CocoaPods** for the same dependencies
- **Keep deployment targets consistent** across all targets
- **Clean build folder** after making changes

## Quick Reference Commands

```bash
# Run comprehensive fix
chmod +x comprehensive_fix.sh
./comprehensive_fix.sh

# Manual pod reinstall
pod deintegrate
pod install

# Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Clean pods
pod cache clean --all
rm -rf Pods/
pod install
```

## Expected Outcome

After applying all fixes:
- ✅ No "Multiple commands produce" errors
- ✅ No deployment target warnings
- ✅ No duplicate framework errors
- ✅ Clean build and successful app launch
- ✅ All Firebase features working correctly 