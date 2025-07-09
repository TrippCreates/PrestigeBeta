import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    @State private var selectedTab = 0
    @State private var showProfile = false
    @State private var showProfileCreation = false
    @State private var showSettings = false
    @StateObject private var firebaseManager = FirebaseManager.shared
    @StateObject private var profileService = ProfileService()
    
    var body: some View {
        ZStack {
            PrestigeTheme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Button(action: { showProfile = true }) {
                        if let profile = profileService.currentProfile, let firstPhoto = profile.photos.first {
                            AsyncImage(url: URL(string: firstPhoto)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(PrestigeTheme.colors.primary)
                            }
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle")
                                .font(.system(size: 24))
                                .foregroundColor(PrestigeTheme.colors.primary)
                        }
                    }
                    
                    Spacer()
                    
                    Text("PRESTIGE")
                        .font(PrestigeTheme.fonts.systemTitle)
                        .foregroundColor(PrestigeTheme.colors.primary)
                        .tracking(4)
                    
                    Spacer()
                    
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 24))
                            .foregroundColor(PrestigeTheme.colors.primary)
                    }
                }
                .padding()
                .background(PrestigeTheme.colors.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                
                // Tab View Content
                TabView(selection: $selectedTab) {
                    DiscoverView()
                        .tabItem {
                            Image(systemName: "sparkles")
                            Text("Discover")
                        }
                        .tag(0)
                    
                    MatchesView()
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Matches")
                        }
                        .tag(1)
                    
                    MessagesView()
                        .tabItem {
                            Image(systemName: "message.fill")
                            Text("Messages")
                        }
                        .tag(2)

                    MVPView()
                        .tabItem {
                            Image(systemName: "trophy.fill")
                            Text("MVP")
                        }
                        .tag(3)
                }
                .accentColor(PrestigeTheme.colors.accent)
            }
        }
        .sheet(isPresented: $showProfile) {
            if let profile = profileService.currentProfile {
                UserProfileView(profile: profile)
            }
        }
        .sheet(isPresented: $showProfileCreation) {
            ProfileCreationView()
        }
        .sheet(isPresented: $showSettings) {
            PrivacySettingsView()
        }
        .onAppear {
            loadUserProfile()
        }
    }
    
    private func loadUserProfile() {
        Task {
            do {
                if let profile = try await profileService.fetchProfile() {
                    // Profile loaded successfully
                    await MainActor.run {
                        profileService.currentProfile = profile
                    }
                } else {
                    // No profile exists, show profile creation
                    await MainActor.run {
                        showProfileCreation = true
                    }
                }
            } catch {
                print("Error loading profile: \(error.localizedDescription)")
            }
        }
    }
}

// Discover View - Main matching interface
struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if viewModel.profiles.isEmpty {
                    VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 40))
                            .foregroundColor(PrestigeTheme.colors.textSecondary)
                        Text("No profiles to show yet")
                            .font(PrestigeTheme.fonts.systemHeadline)
                            .foregroundColor(PrestigeTheme.colors.textSecondary)
                    }
                    .padding()
                } else {
                    // Featured Profiles Card
                    VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                        Text("Today's Selections")
                            .font(PrestigeTheme.fonts.systemHeadline)
                            .foregroundColor(PrestigeTheme.colors.primary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                                ForEach(viewModel.profiles) { profile in
                                    ProfileCard(profile: profile)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .onAppear {
            viewModel.loadProfiles()
        }
    }
}

// Profile Card Component
struct ProfileCard: View {
    let profile: UserProfile
    @State private var showFullProfile = false
    @State private var localRightSwipes: Int = 0
    @State private var localTotalSwipes: Int = 0
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                // Main profile image
                if let imageUrl = profile.photos.first {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(PrestigeTheme.colors.taupe)
                    }
                    .frame(width: 320, height: 480)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                } else {
                    Rectangle()
                        .fill(PrestigeTheme.colors.taupe)
                        .frame(width: 320, height: 480)
                        .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                }
                
                // Gradient overlay
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.black.opacity(0.7),
                            Color.black.opacity(0)
                        ]
                    ),
                    startPoint: .bottom,
                    endPoint: .center
                )
                .frame(height: 200)
                
                // Profile info overlay
                VStack(alignment: .leading, spacing: 12) {
                    // Name and verification
                    HStack(alignment: .center) {
                        Text("\(profile.firstName), \(profile.age)")
                            .font(PrestigeTheme.fonts.systemTitle)
                            .foregroundColor(.white)
                        
                        if profile.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(PrestigeTheme.colors.accent)
                                .font(.system(size: 20))
                        }
                    }
                    
                    // University and status
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(PrestigeTheme.colors.cream)
                            Text(profile.education.university)
                                .foregroundColor(PrestigeTheme.colors.cream)
                                .font(PrestigeTheme.fonts.systemBody)
                        }
                        
                        HStack {
                            Image(systemName: "graduationcap.fill")
                                .foregroundColor(PrestigeTheme.colors.cream)
                            Text("Class of \(profile.education.graduationYear)")
                                .foregroundColor(PrestigeTheme.colors.cream)
                                .font(PrestigeTheme.fonts.systemBody)
                        }
                    }
                    
                    // Quick facts
                    HStack(spacing: 12) {
                        TagView(text: profile.career.position, icon: "briefcase.fill")
                        if let location = profile.location {
                            TagView(text: "\(location.latitude), \(location.longitude)", icon: "location.fill")
                        }
                    }
                }
                .padding(.bottom, 24)
                .padding(.horizontal, 20)
            }
            
            // Action buttons
            HStack(spacing: 24) {
                ActionButton(icon: "xmark", color: PrestigeTheme.colors.secondary) {
                    // Handle pass (left swipe)
                    localTotalSwipes += 1
                    Task {
                        try? await ProfileService().incrementSwipeCounters(for: profile.id, isRightSwipe: false)
                    }
                }
                ActionButton(icon: "star.fill", color: PrestigeTheme.colors.accent) {
                    // Handle super like (count as right swipe)
                    localRightSwipes += 1
                    localTotalSwipes += 1
                    Task {
                        try? await ProfileService().incrementSwipeCounters(for: profile.id, isRightSwipe: true)
                    }
                }
                ActionButton(icon: "heart.fill", color: PrestigeTheme.colors.secondary) {
                    // Handle like (right swipe)
                    localRightSwipes += 1
                    localTotalSwipes += 1
                    Task {
                        try? await ProfileService().incrementSwipeCounters(for: profile.id, isRightSwipe: true)
                    }
                }
            }
            .padding(.top, 16)
        }
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
        .onTapGesture {
            showFullProfile = true
        }
        .sheet(isPresented: $showFullProfile) {
            UserProfileView(profile: profile)
        }
    }
}

// Supporting components for ProfileCard
struct TagView: View {
    let text: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
            Text(text)
                .font(PrestigeTheme.fonts.systemCaption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(PrestigeTheme.colors.cream.opacity(0.2))
        .cornerRadius(16)
        .foregroundColor(PrestigeTheme.colors.cream)
    }
}

struct ActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(PrestigeTheme.colors.cardBackground)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
}

// ViewModel for Discover View
class DiscoverViewModel: ObservableObject {
    @Published var profiles: [UserProfile] = []
    @Published var isLoading = false
    
    func loadProfiles() {
        isLoading = true
        // TODO: Load profiles from Firebase
        // For now, we'll just set loading to false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }
}

// Standout Card Component
struct StandoutCard: View {
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                // Profile image
                Rectangle()
                    .fill(PrestigeTheme.colors.taupe)
                    .frame(height: 260)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                
                // Premium gradient overlay
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            PrestigeTheme.colors.secondary.opacity(0.8),
                            PrestigeTheme.colors.secondary.opacity(0)
                        ]
                    ),
                    startPoint: .bottom,
                    endPoint: .center
                )
                
                // Profile info
                VStack(alignment: .leading, spacing: 12) {
                    // Standout badge
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(PrestigeTheme.colors.accent)
                        Text("Standout")
                            .font(PrestigeTheme.fonts.systemCaption)
                            .foregroundColor(PrestigeTheme.colors.accent)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(16)
                    
                    // Name and info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Michael, 29")
                            .font(PrestigeTheme.fonts.systemTitle)
                            .foregroundColor(PrestigeTheme.colors.cream)
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "building.columns.fill")
                                    .foregroundColor(PrestigeTheme.colors.accent)
                                Text("Princeton")
                                    .foregroundColor(PrestigeTheme.colors.cream)
                            }
                            .font(PrestigeTheme.fonts.systemCaption)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(PrestigeTheme.colors.accent)
                                Text("Investment Banking")
                                    .foregroundColor(PrestigeTheme.colors.cream)
                            }
                            .font(PrestigeTheme.fonts.systemCaption)
                        }
                    }
                }
                .padding()
            }
        }
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

// Matches View
struct MatchesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingLarge) {
                Text("Your Matches")
                    .font(PrestigeTheme.fonts.systemTitle)
                    .foregroundColor(PrestigeTheme.colors.primary)
                    .padding()
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: PrestigeTheme.spacing.paddingMedium) {
                    ForEach(0..<6) { _ in
                        MatchCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Match Card Component
struct MatchCard: View {
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                // Profile image
                Rectangle()
                    .fill(PrestigeTheme.colors.taupe)
                    .frame(height: 240)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                
                // Gradient overlay
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.black.opacity(0.7),
                            Color.black.opacity(0)
                        ]
                    ),
                    startPoint: .bottom,
                    endPoint: .center
                )
                
                // Profile info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Emma")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.cream)
                            
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .foregroundColor(PrestigeTheme.colors.accent)
                                    .font(.system(size: 12))
                                Text("Yale '24")
                                    .font(PrestigeTheme.fonts.systemCaption)
                                    .foregroundColor(PrestigeTheme.colors.cream)
                            }
                        }
                        
                        Spacer()
                        
                        // Online status indicator with animation
                        Circle()
                            .fill(PrestigeTheme.colors.sage)
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )
                    }
                    
                    // Match percentage or compatibility indicator
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(PrestigeTheme.colors.accent)
                        Text("98% Match")
                            .font(PrestigeTheme.fonts.systemCaption)
                            .foregroundColor(PrestigeTheme.colors.cream)
                    }
                }
                .padding()
            }
        }
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

// Messages View
struct MessagesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                Text("Messages")
                    .font(PrestigeTheme.fonts.systemTitle)
                    .foregroundColor(PrestigeTheme.colors.primary)
                    .padding()
                
                ForEach(0..<5) { _ in
                    MessageRow()
                }
            }
        }
    }
}

// Message Row Component
struct MessageRow: View {
    var body: some View {
        HStack(spacing: PrestigeTheme.spacing.paddingMedium) {
            // Profile image
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(PrestigeTheme.colors.taupe)
                    .frame(width: 64, height: 64)
                    .overlay(
                        Circle()
                            .stroke(PrestigeTheme.colors.cardBackground, lineWidth: 2)
                    )
                
                // Online indicator
                Circle()
                    .fill(PrestigeTheme.colors.sage)
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle()
                            .stroke(PrestigeTheme.colors.cardBackground, lineWidth: 2)
                    )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                // Name and verification
                HStack {
                    Text("Alexandra")
                        .font(PrestigeTheme.fonts.systemHeadline)
                        .foregroundColor(PrestigeTheme.colors.primary)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(PrestigeTheme.colors.accent)
                        .font(.system(size: 14))
                }
                
                // University and preview
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "building.columns.fill")
                            .foregroundColor(PrestigeTheme.colors.secondary)
                            .font(.system(size: 12))
                        Text("Stanford University")
                            .font(PrestigeTheme.fonts.systemCaption)
                            .foregroundColor(PrestigeTheme.colors.textSecondary)
                    }
                    
                    Text("Would love to hear more about your research...")
                        .font(PrestigeTheme.fonts.systemCaption)
                        .foregroundColor(PrestigeTheme.colors.textSecondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Time and unread indicator
            VStack(alignment: .trailing, spacing: 6) {
                Text("2m")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                
                Circle()
                    .fill(PrestigeTheme.colors.secondary)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(PrestigeTheme.colors.cardBackground)
        .cornerRadius(PrestigeTheme.spacing.cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

// MVP View for Most Valuable Profiles
struct MVPView: View {
    // Placeholder MVP profiles (replace with real data later)
    let mvpProfiles: [UserProfile] = [
        UserProfile(
            id: "1",
            firstName: "Ava",
            lastName: "Smith",
            age: 23,
            gender: "Female",
            education: Education(university: "Harvard", degree: "BA", graduationYear: 2024, isVerified: true),
            career: Career(company: "Tech Co", position: "Engineer", industry: "Tech", isVerified: true),
            photos: ["https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=facearea&w=400&h=500&facepad=2"],
            bio: "Driven and passionate about innovation.",
            interests: ["Tech", "Travel"],
            location: nil,
            isVerified: true,
            verificationStatus: .verified,
            height: nil,
            ethnicity: nil,
            religion: nil,
            lookingFor: nil,
            rightSwipes: 0,
            totalSwipes: 0
        ),
        UserProfile(
            id: "2",
            firstName: "Liam",
            lastName: "Johnson",
            age: 24,
            gender: "Male",
            education: Education(university: "Stanford", degree: "BS", graduationYear: 2023, isVerified: true),
            career: Career(company: "Finance Inc", position: "Analyst", industry: "Finance", isVerified: false),
            photos: ["https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=facearea&w=400&h=500&facepad=2"],
            bio: "Finance enthusiast and foodie.",
            interests: ["Finance", "Food"],
            location: nil,
            isVerified: true,
            verificationStatus: .verified,
            height: nil,
            ethnicity: nil,
            religion: nil,
            lookingFor: nil,
            rightSwipes: 0,
            totalSwipes: 0
        ),
        UserProfile(
            id: "3",
            firstName: "Sophia",
            lastName: "Lee",
            age: 22,
            gender: "Female",
            education: Education(university: "Yale", degree: "BA", graduationYear: 2025, isVerified: true),
            career: Career(company: "Design Studio", position: "Designer", industry: "Design", isVerified: true),
            photos: ["https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=facearea&w=400&h=500&facepad=2"],
            bio: "Creative mind and coffee lover.",
            interests: ["Art", "Coffee"],
            location: nil,
            isVerified: true,
            verificationStatus: .verified,
            height: nil,
            ethnicity: nil,
            religion: nil,
            lookingFor: nil,
            rightSwipes: 0,
            totalSwipes: 0
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingLarge) {
            Text("Featured MVPs")
                .font(PrestigeTheme.fonts.systemTitle)
                .foregroundColor(PrestigeTheme.colors.primary)
                .padding(.top)
                .padding(.horizontal)
            
            if mvpProfiles.isEmpty {
                VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                    Image(systemName: "star.slash.fill")
                        .font(.system(size: 40))
                        .foregroundColor(PrestigeTheme.colors.textSecondary)
                    Text("No MVPs yet. Profiles with 75%+ right swipes will be featured here!")
                        .font(PrestigeTheme.fonts.systemBody)
                        .foregroundColor(PrestigeTheme.colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                        ForEach(mvpProfiles) { profile in
                            ZStack(alignment: .topTrailing) {
                                VStack(spacing: 0) {
                                    ProfileCard(profile: profile)
                                        .frame(width: 320, height: 480)
                                    // Always show action buttons below the card
                                    HStack(spacing: 24) {
                                        ActionButton(icon: "xmark", color: PrestigeTheme.colors.secondary) {}
                                        ActionButton(icon: "bubble.left", color: PrestigeTheme.colors.accent) {}
                                        ActionButton(icon: "heart.fill", color: PrestigeTheme.colors.secondary) {}
                                    }
                                    .padding(.vertical, 12)
                                }
                                // MVP Badge
                                HStack(spacing: 4) {
                                    Image(systemName: "trophy.fill")
                                        .foregroundColor(PrestigeTheme.colors.accent)
                                    Text("MVP")
                                        .font(PrestigeTheme.fonts.systemCaption)
                                        .foregroundColor(PrestigeTheme.colors.accent)
                                }
                                .padding(8)
                                .background(PrestigeTheme.colors.cardBackground.opacity(0.9))
                                .cornerRadius(12)
                                .shadow(radius: 4)
                                .padding([.top, .trailing], 12)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(PrestigeTheme.colors.cardBackground)
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                            )
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
        .background(PrestigeTheme.colors.background)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
} 