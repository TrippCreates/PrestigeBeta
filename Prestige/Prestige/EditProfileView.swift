import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = "Sarah Johnson"
    @State private var bio: String = "Harvard '22 | Economics\nLooking for meaningful connections"
    @State private var age: String = "27"
    @State private var occupation: String = "Investment Banking Analyst"
    @State private var company: String = "Goldman Sachs"
    @State private var location: String = "New York, NY"
    @State private var height: String = "5'7\""
    @State private var selectedInterests: Set<String> = ["Finance", "Art & Culture", "Travel"]
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var photos: [UIImage?] = Array(repeating: nil, count: 6)
    @State private var selectedPhotoIndex: Int? = nil
    
    let interests = [
        "Art & Culture", "Travel", "Music", "Food & Wine",
        "Finance", "Reading", "Technology", "Photography",
        "Fashion", "Sports", "Investment", "Entrepreneurship",
        "Philanthropy", "Politics", "Science", "Environment"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                    // Photos Section
                    VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                        SectionHeader(title: "Photos", subtitle: "Add up to 6 photos")
                        
                        PhotoGridView(
                            photos: $photos,
                            selectedIndex: $selectedPhotoIndex,
                            showImagePicker: $showImagePicker
                        )
                    }
                    .padding(.horizontal)
                    
                    // Basic Information Section
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
                    
                    // Career Section
                    VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                        SectionHeader(title: "Career", subtitle: "Share your professional background")
                        
                        VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                            ProfileField(title: "Occupation", text: $occupation)
                            ProfileField(title: "Company", text: $company)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Education Info (Read-only since it's verified)
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
                    
                    // Bio Section
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
                    
                    // Interests Section
                    VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                        SectionHeader(title: "Interests", subtitle: "Select up to 8 interests")
                        
                        FlowLayout(spacing: 8) {
                            ForEach(interests, id: \.self) { interest in
                                InterestTag(
                                    title: interest,
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
                .padding(.vertical)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(PrestigeTheme.colors.accent),
                trailing: Button("Save") {
                    // Save profile changes
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(PrestigeTheme.colors.accent)
            )
        }
        .sheet(isPresented: $showImagePicker) {
            if let selectedIndex = selectedPhotoIndex {
                ImagePicker(image: $photos[selectedIndex])
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