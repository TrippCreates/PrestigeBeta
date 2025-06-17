# 🔧 Manual PIF Error Fix

## Problem
The PIF error occurs because your project has **both Swift Package Manager Firebase dependencies AND CocoaPods Firebase dependencies**, causing conflicts.

## Solution: Remove Swift Package Manager Dependencies

### Step 1: Open Xcode
1. Close Xcode completely
2. Open `Prestige.xcworkspace` (NOT .xcodeproj)

### Step 2: Remove Package Dependencies
1. In the **Project Navigator** (left sidebar), look for **"Package Dependencies"** section
2. You should see Firebase packages listed there
3. **Right-click on each Firebase package** and select **"Remove Package"**
4. Remove ALL Firebase-related packages:
   - Firebase
   - FirebaseAnalytics
   - FirebaseAuth
   - FirebaseCore
   - FirebaseFirestore
   - FirebaseStorage
   - FirebaseMessaging
   - Any other Firebase packages

### Step 3: Clean Package Caches
1. Go to **File > Packages > Reset Package Caches**
2. Go to **File > Packages > Resolve Package Versions**

### Step 4: Clean Build
1. Go to **Product > Clean Build Folder**
2. Close Xcode completely
3. Reopen `Prestige.xcworkspace`

### Step 5: Build and Test
1. Select your target device/simulator
2. Press **Cmd + R** to build and run

## Alternative: Complete Reset

If the above doesn't work, try this complete reset:

### Option 1: Reset in Xcode
1. **File > Packages > Reset Package Caches**
2. **File > Packages > Resolve Package Versions**
3. **Product > Clean Build Folder**
4. Restart Xcode

### Option 2: Manual Project Reset
1. Close Xcode
2. Run: `./fix_duplicate_dependencies.sh`
3. Open `Prestige.xcworkspace`
4. Follow Step 2 above to remove any remaining packages

## Verification

After removing Swift Package Manager dependencies, you should see:
- ✅ No Firebase packages in "Package Dependencies"
- ✅ Only CocoaPods dependencies in "Pods" section
- ✅ Clean build without PIF errors

## Why This Happens

The PIF error occurs when Xcode tries to manage the same dependencies through multiple systems:
- **Swift Package Manager**: Firebase packages added via Xcode's package manager
- **CocoaPods**: Firebase packages added via Podfile

This creates duplicate GUIDs and conflicts in the Package Index Format (PIF).

## Prevention

To avoid this in the future:
- ✅ Use **only CocoaPods** for Firebase dependencies
- ❌ Don't add Firebase packages via Swift Package Manager
- ✅ Always open `.xcworkspace` when using CocoaPods

## Still Having Issues?

If the PIF error persists after following these steps:

1. **Check for remaining packages**: Look in Project Navigator for any remaining Firebase packages
2. **Reset Xcode**: Quit Xcode, restart your Mac, try again
3. **Use different simulator**: Try building on a different iOS simulator
4. **Check Xcode version**: Ensure you're using Xcode 14+ for iOS 15+ compatibility

---

**Remember**: Always use `Prestige.xcworkspace`, never `Prestige.xcodeproj` when using CocoaPods! 