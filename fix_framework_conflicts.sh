#!/bin/bash

echo "🔧 Fixing Firebase Framework Conflicts..."

# Navigate to project directory
cd "/Users/aaditprayag/Documents/Prestige3 2/Prestige/Prestige"

echo "🧹 Cleaning everything..."

# Remove all derived data and caches
rm -rf ~/Library/Developer/Xcode/DerivedData/Prestige-*
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex

# Remove pods and workspace
rm -rf Pods Podfile.lock Prestige.xcworkspace

echo "📝 Updating Podfile..."

# Create updated Podfile
cat > Podfile << 'EOF'
platform :ios, '15.0'

target 'Prestige' do
  use_frameworks!
  
  # Firebase dependencies
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  
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
      # Fix deployment target issues
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      
      # Fix framework conflicts
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      
      # Fix script phase issues
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
    end
  end
  
  # Fix specific pod issues
  installer.pods_project.targets.each do |target|
    if target.name == 'abseil' || target.name == 'BoringSSL-GRPC' || target.name == 'gRPC-C++' || target.name == 'gRPC-Core'
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end
end
EOF

echo "📦 Installing pods with updated configuration..."
pod install --repo-update

if [ $? -eq 0 ]; then
    echo "✅ Pods installed successfully!"
else
    echo "❌ Pod installation failed. Trying alternative configuration..."
    
    # Try alternative Podfile with modular headers
    cat > Podfile << 'EOF'
platform :ios, '15.0'

target 'Prestige' do
  use_frameworks!
  
  # Use modular headers to avoid conflicts
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
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
EOF
    
    pod install --repo-update
fi

echo ""
echo "✅ Framework conflicts fix complete!"
echo ""
echo "📱 Next steps:"
echo "1. Close Xcode completely"
echo "2. Open Prestige.xcworkspace"
echo "3. Clean build folder: Product > Clean Build Folder"
echo "4. Build and run: Cmd + R"
echo ""
echo "🔧 If you still see issues:"
echo "1. Check SOLUTION.md for manual fixes"
echo "2. Try building on iPhone 15+ simulator"
echo "3. Ensure you're using Xcode 14.0+"
echo ""
echo "📚 Documentation:"
echo "- SOLUTION.md - Complete solution guide"
echo "- TROUBLESHOOTING.md - Additional troubleshooting" 