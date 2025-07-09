import SwiftUI
import PhotosUI
import FirebaseAuth

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var profileService = ProfileService()
    @State private var name: String = ""
    @State private var bio: String = ""
    @State private var age: String = ""
    @State private var occupation: String = ""
    @State private var company: String = ""
    @State private var location: String = ""
    @State private var height: String = ""
    @State private var selectedInterests: Set<String> = []
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var photos: [UIImage?] = Array(repeating: nil, count: 6)
    @State private var selectedPhotoIndex: Int? = nil
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = true
    
    let interests = [
        "Art & Culture", "Travel", "Music", "Food & Wine",
        "Finance", "Reading", "Technology", "Photography",
        "Fashion", "Sports", "Investment", "Entrepreneurship",
        "Philanthropy", "Politics", "Science", "Environment"
    ]
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: PrestigeTheme.colors.accent))
                } else {
                    ScrollView {
                        VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                            photosSection
                            basicInfoSection
                            careerSection
                            educationSection
                            bioSection
                            interestsSection
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            if let selectedIndex = selectedPhotoIndex {
                ImagePicker(image: $photos[selectedIndex])
            }
        }
        .onAppear {
            loadCurrentProfile()
        }
    }
    
    private func loadCurrentProfile() {
        Task {
            do {
                if let profile = try await profileService.fetchProfile() {
                    await MainActor.run {
                        name = "\(profile.firstName) \(profile.lastName)"
                        bio = profile.bio
                        age = String(profile.age)
                        occupation = profile.career.position
                        company = profile.career.company
                        height = profile.height ?? ""
                        selectedInterests = Set(profile.interests)
                        isLoading = false
                    }
                } else {
                    await MainActor.run {
                        errorMessage = "Failed to load profile"
                        showError = true
                        isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                }
            }
        }
    }
    
    private var photosSection: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            SectionHeader(title: "Photos", subtitle: "Add up to 6 photos")
            
            PhotoGridView(
                photos: $photos,
                selectedIndex: $selectedPhotoIndex,
                showImagePicker: $showImagePicker
            )
        }
        .padding(.horizontal)
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            SectionHeader(title: "Basic Information", subtitle: "Tell us about yourself")
            
            VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                ProfileField(title: "Full Name", text: $name)
                ProfileField(title: "Age", text: $age)
                    .keyboardType(.numberPad)
                ProfileField(title: "Height", text: $height)
                ProfileField(title: "Location", text: $location)
            }
        }
        .padding(.horizontal)
    }
    
    private var careerSection: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            SectionHeader(title: "Career", subtitle: "Share your professional background")
            
            VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                ProfileField(title: "Occupation", text: $occupation)
                ProfileField(title: "Company", text: $company)
            }
        }
        .padding(.horizontal)
    }
    
    private var educationSection: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            HStack {
                Text("Education")
                    .font(PrestigeTheme.fonts.systemHeadline)
                    .foregroundColor(PrestigeTheme.colors.primary)
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(PrestigeTheme.colors.sage)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Harvard University")
                        .font(PrestigeTheme.fonts.systemBody)
                        .foregroundColor(PrestigeTheme.colors.primary)
                    Text("Bachelor of Arts in Economics")
                        .font(PrestigeTheme.fonts.systemCaption)
                        .foregroundColor(PrestigeTheme.colors.textSecondary)
                    Text("Class of 2022")
                        .font(PrestigeTheme.fonts.systemCaption)
                        .foregroundColor(PrestigeTheme.colors.textSecondary)
                }
                Spacer()
                Image(systemName: "lock.fill")
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
            }
            .padding()
            .background(PrestigeTheme.colors.cardBackground)
            .cornerRadius(PrestigeTheme.spacing.cornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal)
    }
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            SectionHeader(title: "About Me", subtitle: "Share your story")
            
            TextEditor(text: $bio)
                .frame(height: 120)
                .padding()
                .background(PrestigeTheme.colors.cardBackground)
                .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: PrestigeTheme.spacing.cornerRadius)
                        .stroke(PrestigeTheme.colors.border, lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
    
    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            SectionHeader(title: "Interests", subtitle: "Select up to 8 interests")
            
            FlowLayout(spacing: 8) {
                ForEach(interests, id: \.self) { interest in
                    InterestTag(
                        text: interest,
                        isSelected: selectedInterests.contains(interest)
                    ) {
                        if selectedInterests.contains(interest) {
                            selectedInterests.remove(interest)
                        } else if selectedInterests.count < 8 {
                            selectedInterests.insert(interest)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(PrestigeTheme.colors.accent)
    }
    
    private var saveButton: some View {
        Button(action: {
            Task {
                await saveProfile()
            }
        }) {
            if isSaving {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: PrestigeTheme.colors.accent))
            } else {
                Text("Save")
            }
        }
        .disabled(isSaving)
        .foregroundColor(PrestigeTheme.colors.accent)
    }
    
    private func saveProfile() async {
        isSaving = true
        defer { isSaving = false }
        
        do {
            guard let userId = Auth.auth().currentUser?.uid else {
                throw NSError(domain: "EditProfileView", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            }
            
            // Upload photos first
            let photoUrls = try await profileService.uploadProfilePhotos(photos, userId: userId)
            
            // Create profile object
            let profile = UserProfile(
                id: userId,
                firstName: name.components(separatedBy: " ").first ?? "",
                lastName: name.components(separatedBy: " ").last ?? "",
                age: Int(age) ?? 0,
                gender: "", // Add gender field to UI if needed
                education: Education(
                    university: "Harvard University",
                    degree: "Bachelor of Arts in Economics",
                    graduationYear: 2022,
                    isVerified: true
                ),
                career: Career(
                    company: company,
                    position: occupation,
                    industry: "Finance",
                    isVerified: false
                ),
                photos: photoUrls,
                bio: bio,
                interests: Array(selectedInterests),
                location: nil, // Convert location string to GeoPoint if needed
                isVerified: false,
                verificationStatus: .pending,
                height: height,
                ethnicity: nil,
                religion: nil,
                lookingFor: nil,
                rightSwipes: 0,
                totalSwipes: 0
            )
            
            // Save profile to Firestore
            try await profileService.saveProfile(profile)
            
            // Dismiss view on success
            await MainActor.run {
                presentationMode.wrappedValue.dismiss()
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

// Section Header Component
struct SectionHeader: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(PrestigeTheme.fonts.systemHeadline)
                .foregroundColor(PrestigeTheme.colors.primary)
            
            Text(subtitle)
                .font(PrestigeTheme.fonts.systemCaption)
                .foregroundColor(PrestigeTheme.colors.textSecondary)
        }
    }
}

// Photo Grid View
struct PhotoGridView: View {
    @Binding var photos: [UIImage?]
    @Binding var selectedIndex: Int?
    @Binding var showImagePicker: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: PrestigeTheme.spacing.paddingMedium) {
            ForEach(0..<6) { index in
                PhotoCell(
                    image: photos[index],
                    isFirst: index == 0
                ) {
                    selectedIndex = index
                    showImagePicker = true
                }
            }
        }
    }
}

// Profile Field Component
struct ProfileField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(PrestigeTheme.fonts.systemCaption)
                .foregroundColor(PrestigeTheme.colors.textSecondary)
            
            TextField("", text: $text)
                .font(PrestigeTheme.fonts.systemBody)
                .padding()
                .background(PrestigeTheme.colors.cardBackground)
                .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: PrestigeTheme.spacing.cornerRadius)
                        .stroke(PrestigeTheme.colors.border, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
} 
