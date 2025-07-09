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
    
    func createUserAndSendVerification(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let user = result?.user else {
                completion(false, "Failed to create user")
                return
            }
            
            // Send verification email
            user.sendEmailVerification { error in
                if let error = error {
                    completion(false, "Failed to send verification email: \(error.localizedDescription)")
                    return
                }
                
                // Store verification data in Firestore
                self?.storeVerification(email: email, userId: user.uid) { success, message in
                    completion(success, message)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let user = result?.user else {
                completion(false, "Failed to sign in")
                return
            }
            
            if user.isEmailVerified {
                completion(true, "Successfully signed in")
            } else {
                // Sign out if email isn't verified
                try? Auth.auth().signOut()
                completion(false, "Please verify your email before signing in")
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            completion(true, "Password reset email sent")
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
    
    func checkProfileCompletion(userId: String, completion: @escaping (Bool) -> Void) {
        db.collection("profiles").document(userId).getDocument { document, error in
            if let error = error {
                print("Error checking profile completion: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                completion(false)
                return
            }
            
            // Check if all required fields are present
            let data = document.data()
            let requiredFields = ["firstName", "university", "graduationYear", "photos"]
            let hasAllFields = requiredFields.allSatisfy { field in
                data?[field] != nil
            }
            
            completion(hasAllFields)
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
    
    func deleteAccount(completion: @escaping (Bool, String) -> Void) {
        guard let user = auth.currentUser else {
            completion(false, "No user is currently signed in")
            return
        }
        
        // First delete the user's profile data from Firestore
        db.collection("profiles").document(user.uid).delete { error in
            if let error = error {
                completion(false, "Failed to delete profile data: \(error.localizedDescription)")
                return
            }
            
            // Then delete the user's authentication account
            user.delete { error in
                if let error = error {
                    completion(false, "Failed to delete account: \(error.localizedDescription)")
                    return
                }
                
                completion(true, "Account successfully deleted")
            }
        }
    }
} 
