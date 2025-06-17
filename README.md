# 🏆 Prestige - University Dating App

A modern iOS dating app built with SwiftUI and Firebase, designed specifically for university students.

## 📱 Features

### Core Functionality
- **🎓 University Email Verification** - Only university students can join
- **👤 Profile Management** - Complete profile creation and editing
- **💝 Smart Matching** - Swipe-based discovery with intelligent matching
- **💬 Real-time Chat** - Instant messaging with matches
- **⚙️ Privacy Controls** - Comprehensive privacy and notification settings
- **🔐 Secure Authentication** - Firebase-based user authentication

### Technical Stack
- **Frontend**: SwiftUI (iOS 15+ compatible)
- **Backend**: Firebase (Auth, Firestore, Storage, Messaging, Analytics)
- **Dependencies**: CocoaPods
- **Architecture**: MVVM with clean separation of concerns

## 🚀 Quick Start

### Prerequisites
- Xcode 14.0+ (recommended: Xcode 15.0+)
- iOS 15.0+ deployment target
- CocoaPods installed
- Firebase project configured

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Prestige
   ```

2. **Install dependencies**
   ```bash
   pod install
   ```

3. **Add Firebase configuration**
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add it to the Xcode project (drag and drop)

4. **Open workspace**
   ```bash
   open Prestige.xcworkspace
   ```

5. **Build and run**
   - Select iPhone 15+ simulator
   - Press `Cmd + R`

## 🔧 Setup Scripts

### Automated Setup
```bash
./setup.sh
```

### Verify Setup
```bash
./verify_setup.sh
```

### Build Project
```bash
./build_project.sh
```

## 📁 Project Structure

```
Prestige/
├── Prestige/                    # Main app source
│   ├── PrestigeApp.swift       # App entry point
│   ├── LandingPage.swift       # Welcome screen
│   ├── LoginPage.swift         # Authentication
│   ├── VerificationPage.swift  # Email verification
│   ├── ProfileCreationView.swift # Profile setup
│   ├── DashboardView.swift     # Main interface
│   ├── ChatView.swift          # Messaging
│   ├── ProfileView.swift       # User profiles
│   ├── EditProfileView.swift   # Profile editing
│   ├── Backend/                # Firebase integration
│   │   ├── FirebaseManager.swift
│   │   └── FirebaseMessagingManager.swift
│   ├── Theme.swift             # App styling
│   ├── SharedComponents.swift  # Reusable UI components
│   └── Assets.xcassets/        # Images and colors
├── PrestigeTests/              # Unit tests
├── PrestigeUITests/            # UI tests
├── Podfile                     # CocoaPods dependencies
└── GoogleService-Info.plist    # Firebase configuration
```

## 🔥 Firebase Setup

### Required Services
1. **Authentication** - Email/password login
2. **Firestore Database** - User data and matches
3. **Storage** - Profile photos
4. **Messaging** - Push notifications
5. **Analytics** - App usage tracking

### Configuration Steps
1. Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add iOS app with your bundle ID
3. Download `GoogleService-Info.plist`
4. Enable required services in Firebase Console
5. Configure security rules for Firestore and Storage

For detailed Firebase setup, see [FIREBASE_SETUP.md](FIREBASE_SETUP.md).

## 🎨 UI/UX Features

### Design System
- **Modern SwiftUI** - Native iOS design patterns
- **Dark/Light Mode** - Automatic theme switching
- **Accessibility** - VoiceOver and Dynamic Type support
- **Responsive Layout** - Works on all iPhone sizes

### Key Screens
- **Landing Page** - Beautiful welcome with app introduction
- **Verification** - University email verification flow
- **Profile Creation** - Guided profile setup with photo upload
- **Dashboard** - Main matching interface with swipe gestures
- **Chat** - Real-time messaging with typing indicators
- **Settings** - Privacy, notifications, and account management

## 🔒 Privacy & Security

### Data Protection
- **University Verification** - Only verified university emails
- **Profile Privacy** - Granular privacy controls
- **Secure Storage** - Firebase Security Rules
- **GDPR Compliance** - Data deletion and export options

### User Controls
- **Profile Visibility** - Control who can see your profile
- **Message Privacy** - Block and report features
- **Data Export** - Download your data anytime
- **Account Deletion** - Permanent account removal

## 🧪 Testing

### Unit Tests
```bash
# Run unit tests
xcodebuild test -workspace Prestige.xcworkspace -scheme Prestige -destination 'platform=iOS Simulator,name=iPhone 15'
```

### UI Tests
```bash
# Run UI tests
xcodebuild test -workspace Prestige.xcworkspace -scheme PrestigeUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🚨 Troubleshooting

### Common Issues
- **Build Errors** - See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Firebase Issues** - Check [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- **PIF Errors** - See [FINAL_PIF_SOLUTION.md](FINAL_PIF_SOLUTION.md)

### Verification Commands
```bash
# Check project setup
./verify_setup.sh

# Fix common issues
./fix_duplicate_dependencies.sh
```

## 📊 App Status

### ✅ Completed Features
- [x] User authentication and verification
- [x] Profile creation and management
- [x] Matching algorithm and interface
- [x] Real-time chat system
- [x] Privacy and notification settings
- [x] Firebase backend integration
- [x] Modern SwiftUI interface
- [x] iOS 15+ compatibility

### 🚧 In Development
- [ ] Advanced matching algorithms
- [ ] Video chat integration
- [ ] Social features and events
- [ ] Premium subscription model

## 🤝 Contributing

### Development Guidelines
1. Follow SwiftUI best practices
2. Maintain MVVM architecture
3. Write unit tests for new features
4. Update documentation
5. Follow Firebase security best practices

### Code Style
- Use SwiftUI for all new UI components
- Follow Apple's Human Interface Guidelines
- Implement proper error handling
- Add accessibility features

## 📄 License

This project is proprietary software. All rights reserved.

## 📞 Support

For technical support or questions:
- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Review [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- Run verification scripts for diagnostics

---

**Built with ❤️ for university students** 