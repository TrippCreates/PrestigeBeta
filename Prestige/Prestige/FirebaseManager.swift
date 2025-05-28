import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    @Published var verificationStatus: String = ""
    @Published var isEmailVerified: Bool = false
    
    private init() {
        // Initialize Firebase if not already initialized
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        // Test Firebase connection
        testConnection()
    }
    
    private func testConnection() {
        // Try to access Firestore
        db.collection("test").document("test").setData([
            "timestamp": FieldValue.serverTimestamp() as Any
        ]) { error in
            if let error = error {
                print("❌ Firebase connection failed: \(error.localizedDescription)")
            } else {
                print("✅ Firebase connected successfully!")
                // Clean up test document
                self.db.collection("test").document("test").delete()
            }
        }
    }
    
    func createUserAndSendVerification(email: String, completion: @escaping (Bool, String) -> Void) {
        // Generate a random password for the temporary account
        let temporaryPassword = UUID().uuidString
        
        print("Attempting to create user with email: \(email)")
        
        // Create user account
        auth.createUser(withEmail: email, password: temporaryPassword) { [weak self] result, error in
            if let error = error as NSError? {
                print("Detailed Firebase Auth Error:")
                print("Error Code: \(error.code)")
                print("Error Domain: \(error.domain)")
                print("Error Description: \(error.localizedDescription)")
                if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                    print("Underlying Error: \(underlyingError)")
                }
                
                // Provide more user-friendly error messages
                let errorMessage: String
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    errorMessage = "This email is already registered."
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "Please enter a valid email address."
                case AuthErrorCode.networkError.rawValue:
                    errorMessage = "Network error. Please check your internet connection."
                default:
                    errorMessage = "Error creating user: \(error.localizedDescription)"
                }
                
                completion(false, errorMessage)
                return
            }
            
            guard let user = result?.user else {
                completion(false, "Error: No user created")
                return
            }
            
            print("User created successfully, sending verification email...")
            
            // Send email verification
            user.sendEmailVerification { error in
                if let error = error {
                    print("Error sending verification email: \(error.localizedDescription)")
                    completion(false, "Error sending verification email: \(error.localizedDescription)")
                    return
                }
                
                // Store user data in Firestore
                self?.storeVerification(email: email, userId: user.uid) { success, message in
                    completion(success, "Verification email sent! Please check your inbox.")
                }
            }
        }
    }
    
    func checkEmailVerificationStatus(email: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = auth.currentUser else {
            completion(false)
            return
        }
        
        currentUser.reload { [weak self] error in
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            self?.isEmailVerified = currentUser.isEmailVerified
            completion(currentUser.isEmailVerified)
        }
    }
    
    private func storeVerification(email: String, userId: String, completion: @escaping (Bool, String) -> Void) {
        let timestamp: Any = FieldValue.serverTimestamp()
        let verificationData: [String: Any] = [
            "email": email,
            "userId": userId,
            "timestamp": timestamp,
            "status": "pending",
            "isVerified": false
        ]
        
        db.collection("verifications").document(email).setData(verificationData) { error in
            if let error = error {
                completion(false, "Error: \(error.localizedDescription)")
            } else {
                completion(true, "Verification data stored successfully!")
            }
        }
    }
    
    func updateVerificationStatus(email: String, isVerified: Bool) {
        let verifiedAt: Any = isVerified ? FieldValue.serverTimestamp() as Any : NSNull()
        
        db.collection("verifications").document(email).updateData([
            "status": isVerified ? "verified" : "pending",
            "isVerified": isVerified,
            "verifiedAt": verifiedAt
        ])
    }
} 
