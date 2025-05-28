import SwiftUI

struct DashboardView: View {
    @State private var selectedTab = 0
    @State private var showProfile = false
    
    var body: some View {
        ZStack {
            PrestigeTheme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Button(action: { showProfile = true }) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 24))
                            .foregroundColor(PrestigeTheme.colors.primary)
                    }
                    
                    Spacer()
                    
                    Text("PRESTIGE")
                        .font(PrestigeTheme.fonts.systemTitle)
                        .foregroundColor(PrestigeTheme.colors.primary)
                        .tracking(4)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell")
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
                }
                .accentColor(PrestigeTheme.colors.accent)
            }
        }
        .sheet(isPresented: $showProfile) {
            UserProfileView()
        }
    }
}

// Discover View - Main matching interface
struct DiscoverView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                // Featured Profiles Card
                VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                    Text("Today's Selections")
                        .font(PrestigeTheme.fonts.systemHeadline)
                        .foregroundColor(PrestigeTheme.colors.primary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                            ForEach(0..<5) { _ in
                                ProfileCard()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                
                // Standouts Section
                VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                    Text("Standouts")
                        .font(PrestigeTheme.fonts.systemHeadline)
                        .foregroundColor(PrestigeTheme.colors.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: PrestigeTheme.spacing.paddingMedium) {
                        ForEach(0..<4) { _ in
                            StandoutCard()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Profile Card Component
struct ProfileCard: View {
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                // Main profile image
                Rectangle()
                    .fill(PrestigeTheme.colors.taupe)
                    .frame(width: 320, height: 480)
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
                .frame(height: 200)
                
                // Profile info overlay
                VStack(alignment: .leading, spacing: 12) {
                    // Name and verification
                    HStack(alignment: .center) {
                        Text("Sarah, 27")
                            .font(PrestigeTheme.fonts.systemTitle)
                            .foregroundColor(.white)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(PrestigeTheme.colors.accent)
                            .font(.system(size: 20))
                    }
                    
                    // University and status
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(PrestigeTheme.colors.cream)
                            Text("Harvard University")
                                .foregroundColor(PrestigeTheme.colors.cream)
                                .font(PrestigeTheme.fonts.systemBody)
                        }
                        
                        HStack {
                            Image(systemName: "graduationcap.fill")
                                .foregroundColor(PrestigeTheme.colors.cream)
                            Text("Class of 2024")
                                .foregroundColor(PrestigeTheme.colors.cream)
                                .font(PrestigeTheme.fonts.systemBody)
                        }
                    }
                    
                    // Quick facts
                    HStack(spacing: 12) {
                        TagView(text: "Finance", icon: "briefcase.fill")
                        TagView(text: "NYC", icon: "location.fill")
                    }
                }
                .padding(.bottom, 24)
                .padding(.horizontal, 20)
            }
            
            // Action buttons
            HStack(spacing: 24) {
                ActionButton(icon: "xmark", color: PrestigeTheme.colors.secondary)
                ActionButton(icon: "star.fill", color: PrestigeTheme.colors.accent)
                ActionButton(icon: "heart.fill", color: PrestigeTheme.colors.secondary)
            }
            .padding(.top, 16)
        }
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
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
    
    var body: some View {
        Button(action: {}) {
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

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
} 