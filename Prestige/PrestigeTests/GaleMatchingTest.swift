import XCTest
import FirebaseFirestore
@testable import Prestige

final class GaleMatchingTest: XCTestCase {
    var matcher: GaleShapleyMatcher!
    
    override func setUp() {
        super.setUp()
        matcher = GaleShapleyMatcher()
    }
    
    func testGaleShapleyMatching() async throws {
        // Create 10 test profiles
        let profiles = [
            Profile(id: "p1", name: "Alice", preferences: [], currentMatch: nil),
            Profile(id: "p2", name: "Bob", preferences: [], currentMatch: nil),
            Profile(id: "p3", name: "Charlie", preferences: [], currentMatch: nil),
            Profile(id: "p4", name: "Diana", preferences: [], currentMatch: nil),
            Profile(id: "p5", name: "Eve", preferences: [], currentMatch: nil),
            Profile(id: "p6", name: "Frank", preferences: [], currentMatch: nil),
            Profile(id: "p7", name: "Grace", preferences: [], currentMatch: nil),
            Profile(id: "p8", name: "Henry", preferences: [], currentMatch: nil),
            Profile(id: "p9", name: "Ivy", preferences: [], currentMatch: nil),
            Profile(id: "p10", name: "Jack", preferences: [], currentMatch: nil)
        ]
        
        // Save profiles to Firebase
        let db = Firestore.firestore()
        for profile in profiles {
            try await db.collection("profiles").document(profile.id).setData(from: profile)
        }
        
        // Simulate some swipes (preferences)
        // Alice's preferences
        try await matcher.updatePreferences(for: "p1", swipedRightOn: "p3")
        try await matcher.updatePreferences(for: "p1", swipedRightOn: "p5")
        try await matcher.updatePreferences(for: "p1", swipedRightOn: "p7")
        
        // Bob's preferences
        try await matcher.updatePreferences(for: "p2", swipedRightOn: "p4")
        try await matcher.updatePreferences(for: "p2", swipedRightOn: "p6")
        try await matcher.updatePreferences(for: "p2", swipedRightOn: "p8")
        
        // Charlie's preferences
        try await matcher.updatePreferences(for: "p3", swipedRightOn: "p1")
        try await matcher.updatePreferences(for: "p3", swipedRightOn: "p9")
        try await matcher.updatePreferences(for: "p3", swipedRightOn: "p5")
        
        // Diana's preferences
        try await matcher.updatePreferences(for: "p4", swipedRightOn: "p2")
        try await matcher.updatePreferences(for: "p4", swipedRightOn: "p10")
        try await matcher.updatePreferences(for: "p4", swipedRightOn: "p6")
        
        // Eve's preferences
        try await matcher.updatePreferences(for: "p5", swipedRightOn: "p1")
        try await matcher.updatePreferences(for: "p5", swipedRightOn: "p3")
        try await matcher.updatePreferences(for: "p5", swipedRightOn: "p7")
        
        // Frank's preferences
        try await matcher.updatePreferences(for: "p6", swipedRightOn: "p2")
        try await matcher.updatePreferences(for: "p6", swipedRightOn: "p4")
        try await matcher.updatePreferences(for: "p6", swipedRightOn: "p8")
        
        // Grace's preferences
        try await matcher.updatePreferences(for: "p7", swipedRightOn: "p1")
        try await matcher.updatePreferences(for: "p7", swipedRightOn: "p5")
        try await matcher.updatePreferences(for: "p7", swipedRightOn: "p9")
        
        // Henry's preferences
        try await matcher.updatePreferences(for: "p8", swipedRightOn: "p2")
        try await matcher.updatePreferences(for: "p8", swipedRightOn: "p6")
        try await matcher.updatePreferences(for: "p8", swipedRightOn: "p10")
        
        // Ivy's preferences
        try await matcher.updatePreferences(for: "p9", swipedRightOn: "p3")
        try await matcher.updatePreferences(for: "p9", swipedRightOn: "p7")
        try await matcher.updatePreferences(for: "p9", swipedRightOn: "p1")
        
        // Jack's preferences
        try await matcher.updatePreferences(for: "p10", swipedRightOn: "p4")
        try await matcher.updatePreferences(for: "p10", swipedRightOn: "p8")
        try await matcher.updatePreferences(for: "p10", swipedRightOn: "p2")
        
        // Run the matching algorithm
        try await matcher.runMatching()
        
        // Verify matches
        let matchesSnapshot = try await db.collection("matches").getDocuments()
        let matches = matchesSnapshot.documents.compactMap { doc -> (String, String)? in
            guard let matchedWith = doc.data()["matchedWith"] as? String else { return nil }
            return (doc.documentID, matchedWith)
        }
        
        // Print matches for verification
        print("Final Matches:")
        for (profileId, matchedId) in matches {
            print("\(profileId) matched with \(matchedId)")
        }
        
        // Basic assertions
        XCTAssertFalse(matches.isEmpty, "Should have some matches")
        XCTAssertEqual(matches.count, 10, "Should have 10 matches (5 pairs)")
    }
} 