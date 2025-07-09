import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Combine

class ProfileService: ObservableObject {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    @Published var currentProfile: UserProfile?
    @Published var isLoading = false
    @Published var error: Error?
    
    // Collection paths
    private let profilesCollection = "profiles"
    private let photosCollection = "photos"
    private let educationCollection = "education"
    private let careerCollection = "career"
    
    // Save profile data to Firestore
    func saveProfile(_ profile: UserProfile) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "ProfileService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        // Create a batch write
        let batch = db.batch()
        
        // Save basic profile info
        let profileRef = db.collection(profilesCollection).document(userId)
        let basicProfileData: [String: Any] = [
            "id": profile.id,
            "firstName": profile.firstName,
            "lastName": profile.lastName,
            "age": profile.age,
            "gender": profile.gender,
            "bio": profile.bio,
            "interests": profile.interests,
            "height": profile.height as Any,
            "ethnicity": profile.ethnicity as Any,
            "religion": profile.religion as Any,
            "lookingFor": profile.lookingFor as Any,
            "isVerified": profile.isVerified,
            "verificationStatus": profile.verificationStatus.rawValue,
            "rightSwipes": profile.rightSwipes,
            "totalSwipes": profile.totalSwipes,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        batch.setData(basicProfileData, forDocument: profileRef)
        
        // Save education info
        let educationRef = profileRef.collection(educationCollection).document("current")
        let educationData: [String: Any] = [
            "university": profile.education.university,
            "degree": profile.education.degree,
            "graduationYear": profile.education.graduationYear,
            "isVerified": profile.education.isVerified,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        batch.setData(educationData, forDocument: educationRef)
        
        // Save career info
        let careerRef = profileRef.collection(careerCollection).document("current")
        let careerData: [String: Any] = [
            "company": profile.career.company,
            "position": profile.career.position,
            "industry": profile.career.industry,
            "isVerified": profile.career.isVerified,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        batch.setData(careerData, forDocument: careerRef)
        
        // Save photo references
        let photosRef = profileRef.collection(photosCollection).document("metadata")
        let photosData: [String: Any] = [
            "urls": profile.photos,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        batch.setData(photosData, forDocument: photosRef)
        
        // Commit the batch
        try await batch.commit()
        
        // Update the current profile
        await MainActor.run {
            self.currentProfile = profile
        }
    }
    
    // Upload profile photos to Firebase Storage
    func uploadProfilePhotos(_ photos: [UIImage?], userId: String) async throws -> [String] {
        var photoUrls: [String] = []
        
        for (index, photo) in photos.enumerated() {
            guard let image = photo,
                  let imageData = image.jpegData(compressionQuality: 0.7) else {
                continue
            }
            
            let photoRef = storage.reference().child("\(profilesCollection)/\(userId)/\(photosCollection)/photo_\(index).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            _ = try await photoRef.putDataAsync(imageData, metadata: metadata)
            let downloadURL = try await photoRef.downloadURL()
            photoUrls.append(downloadURL.absoluteString)
        }
        
        return photoUrls
    }
    
    // Fetch user profile from Firestore
    func fetchProfile() async throws -> UserProfile? {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "ProfileService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let profileRef = db.collection(profilesCollection).document(userId)
        
        // Fetch all profile data in parallel
        async let basicProfile = profileRef.getDocument()
        async let education = profileRef.collection(educationCollection).document("current").getDocument()
        async let career = profileRef.collection(careerCollection).document("current").getDocument()
        async let photos = profileRef.collection(photosCollection).document("metadata").getDocument()
        
        // Wait for all documents
        let (profileDoc, educationDoc, careerDoc, photosDoc) = try await (basicProfile, education, career, photos)
        
        guard let profileData = profileDoc.data(),
              let educationData = educationDoc.data(),
              let careerData = careerDoc.data(),
              let photosData = photosDoc.data() else {
            return nil
        }
        
        // Construct the profile object
        let profile = UserProfile(
            id: userId,
            firstName: profileData["firstName"] as? String ?? "",
            lastName: profileData["lastName"] as? String ?? "",
            age: profileData["age"] as? Int ?? 0,
            gender: profileData["gender"] as? String ?? "",
            education: Education(
                university: educationData["university"] as? String ?? "",
                degree: educationData["degree"] as? String ?? "",
                graduationYear: educationData["graduationYear"] as? Int ?? 0,
                isVerified: educationData["isVerified"] as? Bool ?? false
            ),
            career: Career(
                company: careerData["company"] as? String ?? "",
                position: careerData["position"] as? String ?? "",
                industry: careerData["industry"] as? String ?? "",
                isVerified: careerData["isVerified"] as? Bool ?? false
            ),
            photos: photosData["urls"] as? [String] ?? [],
            bio: profileData["bio"] as? String ?? "",
            interests: profileData["interests"] as? [String] ?? [],
            location: nil, // Convert from GeoPoint if needed
            isVerified: profileData["isVerified"] as? Bool ?? false,
            verificationStatus: VerificationStatus(rawValue: profileData["verificationStatus"] as? String ?? "pending") ?? .pending,
            height: profileData["height"] as? String,
            ethnicity: profileData["ethnicity"] as? String,
            religion: profileData["religion"] as? String,
            lookingFor: profileData["lookingFor"] as? String,
            rightSwipes: profileData["rightSwipes"] as? Int ?? 0,
            totalSwipes: profileData["totalSwipes"] as? Int ?? 0
        )
        
        // Update the current profile
        await MainActor.run {
            self.currentProfile = profile
        }
        
        return profile
    }
    
    // Increment swipe counters for a profile
    func incrementSwipeCounters(for userId: String, isRightSwipe: Bool) async throws {
        let profileRef = db.collection(profilesCollection).document(userId)
        var updates: [String: Any] = [
            "totalSwipes": FieldValue.increment(Int64(1))
        ]
        if isRightSwipe {
            updates["rightSwipes"] = FieldValue.increment(Int64(1))
        }
        try await profileRef.updateData(updates)
    }
} 