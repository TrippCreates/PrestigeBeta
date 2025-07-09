import SwiftUI

// FlowLayout implementation
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, proposal: proposal).offsets
        
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: bounds.minX + offset.x, y: bounds.minY + offset.y), proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], proposal: ProposedViewSize) -> (offsets: [CGPoint], size: CGSize) {
        guard let containerWidth = proposal.width else {
            return (sizes.map { _ in .zero }, .zero)
        }
        
        var offsets: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxY: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > containerWidth {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            
            offsets.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxY = max(maxY, currentY + size.height)
        }
        
        return (offsets, CGSize(width: containerWidth, height: maxY))
    }
}

struct UserProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showEditProfile = false
    @State private var showTerms = false
    let profile: UserProfile
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                    // Profile Header
                    VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                        // Profile Image
                        if !profile.photos.isEmpty {
                            AsyncImage(url: URL(string: profile.photos[0])) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .fill(PrestigeTheme.colors.taupe)
                                    .overlay(
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .padding(24)
                                    )
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .padding(.top)
                        } else {
                            Circle()
                                .fill(PrestigeTheme.colors.taupe)
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .padding(24)
                                )
                                .padding(.top)
                        }
                        
                        // Profile Info
                        VStack(spacing: 8) {
                            Text("\(profile.firstName) \(profile.lastName)")
                                .font(PrestigeTheme.fonts.systemTitle)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .foregroundColor(PrestigeTheme.colors.secondary)
                                Text(profile.education.university)
                                    .font(PrestigeTheme.fonts.systemBody)
                                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                            }
                            
                            HStack {
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(PrestigeTheme.colors.secondary)
                                Text(profile.career.position)
                                    .font(PrestigeTheme.fonts.systemBody)
                                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                            }
                        }
                    }
                    
                    // Bio Section
                    if !profile.bio.isEmpty {
                        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                            Text("About")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            
                            Text(profile.bio)
                                .font(PrestigeTheme.fonts.systemBody)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Interests Section
                    if !profile.interests.isEmpty {
                        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                            Text("Interests")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(profile.interests, id: \.self) { interest in
                                    Text(interest)
                                        .font(PrestigeTheme.fonts.systemCaption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(PrestigeTheme.colors.accent.opacity(0.1))
                                        .foregroundColor(PrestigeTheme.colors.accent)
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Additional Photos
                    if profile.photos.count > 1 {
                        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                            Text("Photos")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                                    ForEach(profile.photos.dropFirst(), id: \.self) { photoUrl in
                                        AsyncImage(url: URL(string: photoUrl)) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            Rectangle()
                                                .fill(PrestigeTheme.colors.taupe)
                                        }
                                        .frame(width: 120, height: 160)
                                        .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(PrestigeTheme.colors.primary)
                },
                trailing: Button(action: { showEditProfile = true }) {
                    Text("Edit")
                        .foregroundColor(PrestigeTheme.colors.accent)
                }
            )
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(profile: UserProfile(
            id: "preview",
            firstName: "Sarah",
            lastName: "Johnson",
            age: 25,
            gender: "Female",
            education: Education(
                university: "Harvard University",
                degree: "Bachelor of Arts",
                graduationYear: 2024,
                isVerified: true
            ),
            career: Career(
                company: "Tech Corp",
                position: "Software Engineer",
                industry: "Technology",
                isVerified: false
            ),
            photos: ["https://example.com/photo1.jpg", "https://example.com/photo2.jpg"],
            bio: "I love technology and travel.",
            interests: ["Technology", "Travel"],
            location: nil,
            isVerified: true,
            verificationStatus: .verified,
            height: "5'7\"",
            ethnicity: "Asian",
            religion: "Buddhist",
            lookingFor: "Friendship",
            rightSwipes: 0,
            totalSwipes: 0
        ))
    }
} 
