#!/bin/bash

echo "🚀 Starting Comprehensive Firebase Framework Conflict Fix..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "Podfile" ]; then
    print_error "Podfile not found. Please run this script from your project root directory."
    exit 1
fi

print_status "Step 1: Cleaning all caches and derived data..."

# Clean Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*
print_success "Cleaned Xcode derived data"

# Clean CocoaPods cache
pod cache clean --all
print_success "Cleaned CocoaPods cache"

# Remove existing Pods
rm -rf Pods/
rm -rf Podfile.lock
print_success "Removed existing Pods directory and lock file"

print_status "Step 2: Updating Podfile with correct configuration..."

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

print_success "Updated Podfile with correct configuration"

print_status "Step 3: Installing pods with updated configuration..."

# Install pods
pod install --repo-update
if [ $? -eq 0 ]; then
    print_success "Pods installed successfully"
else
    print_error "Pod installation failed"
    exit 1
fi

print_status "Step 4: Cleaning build folder..."

# Clean build folder
xcodebuild clean -workspace Prestige.xcworkspace -scheme Prestige
print_success "Cleaned build folder"

echo ""
echo "🎉 Comprehensive fix completed!"
echo "=================================================="
echo ""
echo "📋 Next Steps:"
echo "1. Open Prestige.xcworkspace (NOT .xcodeproj)"
echo "2. Follow the manual steps in COMPREHENSIVE_SOLUTION.md"
echo "3. Clean build folder and build the project"
echo ""
echo "⚠️  Important: Always use .xcworkspace, never .xcodeproj"
echo "⚠️  Remove any Firebase packages from Swift Package Manager" 