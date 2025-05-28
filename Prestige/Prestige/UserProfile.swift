import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

// User Profile Data Model
struct UserProfile: Codable, Identifiable {
    var id: String  // Firebase User ID
    var firstName: String
    var lastName: String
    var age: Int
    var gender: String
    var education: Education
    var career: Career
    var photos: [String]  // URLs of photos
    var bio: String
    var interests: [String]
    var location: GeoPoint?
    var isVerified: Bool
    var verificationStatus: VerificationStatus
    
    // Additional profile fields
    var height: String?
    var ethnicity: String?
    var religion: String?
    var lookingFor: String?
}

// Education Information
struct Education: Codable {
    var university: String
    var degree: String
    var graduationYear: Int
    var isVerified: Bool
}

// Career Information
struct Career: Codable {
    var company: String
    var position: String
    var industry: String
    var isVerified: Bool
}

// Verification Status
enum VerificationStatus: String, Codable {
    case pending = "pending"
    case verified = "verified"
    case rejected = "rejected"
} 