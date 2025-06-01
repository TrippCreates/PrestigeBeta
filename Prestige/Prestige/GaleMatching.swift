import Foundation
import FirebaseFirestore

// MARK: - Models
struct Profile: Identifiable, Codable {
    let id: String
    var name: String
    var preferences: [String] // Array of profile IDs in order of preference
    var currentMatch: String?
}

// MARK: - Gale-Shapley Algorithm
class GaleShapleyMatcher {
    private let db = Firestore.firestore()
    
    // Stores the current state of matches
    private var matches: [String: String] = [:] // [profileId: matchedProfileId]
    
    // Stores the current proposal index for each profile
    private var proposalIndices: [String: Int] = [:]
    
    // MARK: - Public Methods
    
    /// Updates a profile's preferences when they swipe right
    func updatePreferences(for profileId: String, swipedRightOn targetId: String) async throws {
        let profileRef = db.collection("profiles").document(profileId)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            db.runTransaction({ transaction, errorPointer in
                let snapshot: DocumentSnapshot
                do {
                    snapshot = try transaction.getDocument(profileRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard var profile = try? snapshot.data(as: Profile.self) else {
                    return nil
                }
                
                // Add the swiped profile to preferences if not already present
                if !profile.preferences.contains(targetId) {
                    profile.preferences.append(targetId)
                    do {
                        try transaction.setData(from: profile, forDocument: profileRef)
                    } catch {
                        errorPointer?.pointee = error as NSError
                        return nil
                    }
                }
                
                return nil
            }) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    /// Runs the matching algorithm
    func runMatching() async throws {
        // Get all profiles
        let profilesSnapshot = try await db.collection("profiles").getDocuments()
        let profiles = try profilesSnapshot.documents.compactMap { try $0.data(as: Profile.self) }
        
        // Initialize proposal indices
        proposalIndices = Dictionary(uniqueKeysWithValues: profiles.map { ($0.id, 0) })
        
        // Initialize matches
        matches = [:]
        
        // Continue until all profiles are matched or have exhausted their preferences
        var hasUnmatchedProfiles = true
        while hasUnmatchedProfiles {
            hasUnmatchedProfiles = false
            
            for profile in profiles {
                // Skip if profile is already matched
                if matches[profile.id] != nil {
                    continue
                }
                
                // Skip if profile has exhausted all preferences
                guard let proposalIndex = proposalIndices[profile.id],
                      proposalIndex < profile.preferences.count else {
                    continue
                }
                
                hasUnmatchedProfiles = true
                
                // Get the next profile to propose to
                let proposedToId = profile.preferences[proposalIndex]
                
                // Check if the proposed profile is already matched
                if let currentMatch = matches[proposedToId] {
                    // Find the proposed profile's preferences
                    guard let proposedProfile = profiles.first(where: { $0.id == proposedToId }) else {
                        continue
                    }
                    
                    // Check if the proposed profile prefers the new match
                    let currentMatchIndex = proposedProfile.preferences.firstIndex(of: currentMatch) ?? Int.max
                    let newMatchIndex = proposedProfile.preferences.firstIndex(of: profile.id) ?? Int.max
                    
                    if newMatchIndex < currentMatchIndex {
                        // Update matches
                        matches[proposedToId] = profile.id
                        matches[profile.id] = proposedToId
                        
                        // Update the rejected profile's proposal index
                        proposalIndices[currentMatch] = (proposalIndices[currentMatch] ?? 0) + 1
                    } else {
                        // Update the proposing profile's proposal index
                        proposalIndices[profile.id] = proposalIndex + 1
                    }
                } else {
                    // Proposed profile is not matched, create new match
                    matches[proposedToId] = profile.id
                    matches[profile.id] = proposedToId
                }
            }
        }
        
        // Save matches to Firebase
        try await saveMatches()
    }
    
    // MARK: - Private Methods
    
    private func saveMatches() async throws {
        let batch = db.batch()
        
        for (profileId, matchedId) in matches {
            let matchRef = db.collection("matches").document(profileId)
            try batch.setData(from: ["matchedWith": matchedId], forDocument: matchRef)
        }
        
        try await batch.commit()
    }
} 