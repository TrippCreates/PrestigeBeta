# 🔥 Firebase Setup Guide

Complete guide to set up Firebase for the Prestige dating app.

## 📋 Prerequisites

- Google account
- Firebase project (or create new one)
- iOS app bundle identifier
- Xcode 14.0+

## 🚀 Step-by-Step Setup

### 1. Create Firebase Project

1. **Go to Firebase Console**
   - Visit [console.firebase.google.com](https://console.firebase.google.com)
   - Sign in with your Google account

2. **Create New Project**
   - Click "Create a project"
   - Enter project name: `Prestige`
   - Enable Google Analytics (recommended)
   - Choose Analytics account or create new
   - Click "Create project"

3. **Configure Project**
   - Accept terms and continue
   - Wait for project creation to complete

### 2. Add iOS App

1. **Add iOS App**
   - Click iOS icon (+ Add app)
   - Enter bundle ID: `com.yourcompany.Prestige`
   - Enter app nickname: `Prestige`
   - Enter App Store ID (optional)
   - Click "Register app"

2. **Download Configuration**
   - Download `GoogleService-Info.plist`
   - **Important**: Keep this file secure

3. **Add to Xcode Project**
   - Drag `GoogleService-Info.plist` into Xcode project
   - Make sure "Copy items if needed" is checked
   - Add to main target

### 3. Enable Required Services

#### Authentication
1. **Go to Authentication**
   - Click "Authentication" in left sidebar
   - Click "Get started"

2. **Enable Email/Password**
   - Click "Sign-in method" tab
   - Enable "Email/Password"
   - Click "Save"

#### Firestore Database
1. **Create Database**
   - Click "Firestore Database" in left sidebar
   - Click "Create database"
   - Choose "Start in test mode" (for development)
   - Select location closest to your users

2. **Security Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users can read/write their own data
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Users can read other user profiles (for matching)
       match /users/{userId} {
         allow read: if request.auth != null;
       }
       
       // Matches - users can read/write their own matches
       match /matches/{matchId} {
         allow read, write: if request.auth != null && 
           (resource.data.user1Id == request.auth.uid || 
            resource.data.user2Id == request.auth.uid);
       }
       
       // Messages - users can read/write messages in their conversations
       match /conversations/{conversationId}/messages/{messageId} {
         allow read, write: if request.auth != null && 
           exists(/databases/$(database)/documents/conversations/$(conversationId)) &&
           (get(/databases/$(database)/documents/conversations/$(conversationId)).data.user1Id == request.auth.uid || 
            get(/databases/$(database)/documents/conversations/$(conversationId)).data.user2Id == request.auth.uid);
       }
     }
   }
   ```

#### Storage
1. **Enable Storage**
   - Click "Storage" in left sidebar
   - Click "Get started"
   - Choose "Start in test mode"
   - Select location

2. **Storage Rules**
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       // Users can upload their own profile photos
       match /profile-photos/{userId}/{allPaths=**} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Users can upload chat images
       match /chat-images/{conversationId}/{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

#### Messaging
1. **Enable Cloud Messaging**
   - Click "Messaging" in left sidebar
   - Click "Get started"
   - Follow setup instructions

2. **Configure APNs**
   - Upload your APNs authentication key
   - Or use Firebase Cloud Messaging HTTP v1 API

#### Analytics
1. **Enable Analytics**
   - Analytics is enabled by default
   - No additional configuration needed

### 4. Configure iOS App

#### Update Info.plist
Add these keys to your `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from `GoogleService-Info.plist`.

#### Add Capabilities
1. **Push Notifications**
   - In Xcode, select your target
   - Go to "Signing & Capabilities"
   - Click "+ Capability"
   - Add "Push Notifications"

2. **Background Modes** (optional)
   - Add "Background Modes" capability
   - Check "Remote notifications"

### 5. Test Configuration

#### Verify Setup
```bash
# Run verification script
./verify_setup.sh
```

#### Test Firebase Connection
1. Build and run the app
2. Check Xcode console for Firebase initialization messages
3. Verify authentication works
4. Test database operations

## 🔧 Troubleshooting

### Common Issues

#### "Firebase not configured" Error
- Ensure `GoogleService-Info.plist` is added to project
- Verify bundle ID matches Firebase project
- Check that Firebase is initialized in `PrestigeApp.swift`

#### Authentication Issues
- Verify Email/Password is enabled in Firebase Console
- Check security rules allow user operations
- Ensure proper error handling in code

#### Database Connection Issues
- Check Firestore security rules
- Verify network connectivity
- Check Firebase project settings

#### Storage Issues
- Verify Storage security rules
- Check file size limits
- Ensure proper file paths

### Debug Commands

```bash
# Check Firebase configuration
grep -r "Firebase" Prestige/

# Verify GoogleService-Info.plist
ls -la GoogleService-Info.plist

# Check pod installation
pod install --verbose
```

## 📊 Monitoring

### Firebase Console
- **Analytics**: User engagement and app usage
- **Crashlytics**: App crashes and errors
- **Performance**: App performance metrics
- **Authentication**: User sign-in analytics

### Security
- **Security Rules**: Monitor rule violations
- **Authentication**: Track sign-in attempts
- **Storage**: Monitor file uploads/downloads

## 🔒 Security Best Practices

### Production Setup
1. **Update Security Rules**
   - Replace test mode rules with production rules
   - Implement proper user authentication checks
   - Add rate limiting

2. **Enable App Check**
   - Add App Check to prevent abuse
   - Configure device verification

3. **Monitor Usage**
   - Set up billing alerts
   - Monitor API usage
   - Track security events

### Data Protection
1. **User Privacy**
   - Implement data deletion
   - Add privacy controls
   - Follow GDPR requirements

2. **Secure Storage**
   - Encrypt sensitive data
   - Use secure file uploads
   - Implement access controls

## 📱 App Integration

### FirebaseManager.swift
The app uses a centralized Firebase manager:

```swift
class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    // Authentication
    func signIn(email: String, password: String)
    func signUp(email: String, password: String)
    func signOut()
    
    // Firestore
    func saveUserProfile(_ profile: UserProfile)
    func getUserProfile(userId: String)
    func createMatch(user1Id: String, user2Id: String)
    
    // Storage
    func uploadProfilePhoto(image: UIImage, userId: String)
    func downloadProfilePhoto(userId: String)
    
    // Messaging
    func sendMessage(conversationId: String, message: Message)
    func getMessages(conversationId: String)
}
```

### Usage Examples
```swift
// Authentication
FirebaseManager.shared.signIn(email: "user@university.edu", password: "password")

// Save user profile
FirebaseManager.shared.saveUserProfile(userProfile)

// Upload photo
FirebaseManager.shared.uploadProfilePhoto(image: selectedImage, userId: userId)
```

## 🎯 Next Steps

1. **Test all Firebase services**
2. **Implement error handling**
3. **Add offline support**
4. **Set up monitoring**
5. **Prepare for production**

---

**Need help?** Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues. 