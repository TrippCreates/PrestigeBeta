import SwiftUI
import PhotosUI

struct ProfileCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentStep = 0
    @State private var photos: [UIImage?] = Array(repeating: nil, count: 6)
    @State private var selectedPhotoIndex: Int? = nil
    @State private var showImagePicker = false
    
    // Profile Information
    @State private var firstName = ""
    @State private var birthDate = Date()
    @State private var university = ""
    @State private var graduationYear = ""
    @State private var occupation = ""
    @State private var company = ""
    @State private var bio = ""
    
    // Selected Interests
    @State private var selectedInterests: Set<String> = []
    
    let steps = ["Photos", "Basics", "Education", "Career", "Bio", "Interests"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Progress Bar
                ProgressBar(currentStep: currentStep, totalSteps: steps.count)
                    .padding()
                
                // Current Step Content
                TabView(selection: $currentStep) {
                    PhotosView(photos: $photos, selectedIndex: $selectedPhotoIndex, showImagePicker: $showImagePicker)
                        .tag(0)
                    
                    BasicInfoView(firstName: $firstName, birthDate: $birthDate)
                        .tag(1)
                    
                    EducationView(university: $university, graduationYear: $graduationYear)
                        .tag(2)
                    
                    CareerView(occupation: $occupation, company: $company)
                        .tag(3)
                    
                    BioView(bio: $bio)
                        .tag(4)
                    
                    InterestsView(selectedInterests: $selectedInterests)
                        .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Navigation Buttons
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < steps.count - 1 {
                        Button("Next") {
                            withAnimation {
                                currentStep += 1
                            }
                        }
                    } else {
                        Button("Complete") {
                            // Save profile
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Create Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showImagePicker) {
            if let selectedIndex = selectedPhotoIndex {
                ImagePicker(image: $photos[selectedIndex])
            }
        }
    }
}

// Progress Bar Component
struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(PrestigeTheme.colors.cardBackground)
                    .frame(height: 4)
                
                Rectangle()
                    .fill(PrestigeTheme.colors.accent)
                    .frame(width: geometry.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 4)
            }
        }
        .frame(height: 4)
    }
}

// Photos View
struct PhotosView: View {
    @Binding var photos: [UIImage?]
    @Binding var selectedIndex: Int?
    @Binding var showImagePicker: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                Text("Add Photos")
                    .font(PrestigeTheme.fonts.systemHeadline)
                    .foregroundColor(PrestigeTheme.colors.primary)
                
                Text("Add up to 6 photos to your profile")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                
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
            .padding()
        }
    }
}

// Photo Cell Component
struct PhotoCell: View {
    let image: UIImage?
    let isFirst: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(PrestigeTheme.colors.cardBackground)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(PrestigeTheme.colors.accent)
                        )
                }
                
                if isFirst && image == nil {
                    VStack {
                        Spacer()
                        Text("Profile Photo")
                            .font(PrestigeTheme.fonts.systemCaption)
                            .foregroundColor(PrestigeTheme.colors.textSecondary)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.5))
                    }
                }
            }
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: PrestigeTheme.spacing.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: PrestigeTheme.spacing.cornerRadius)
                .stroke(
                    isFirst ? PrestigeTheme.colors.accent : Color.clear,
                    lineWidth: isFirst ? 2 : 0
                )
        )
    }
}

// Basic Info View
struct BasicInfoView: View {
    @Binding var firstName: String
    @Binding var birthDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingLarge) {
            VStack(alignment: .leading, spacing: 8) {
                Text("First Name")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                
                TextField("", text: $firstName)
                    .font(PrestigeTheme.fonts.systemBody)
                    .padding()
                    .background(PrestigeTheme.colors.cardBackground)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Birth Date")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                
                DatePicker("", selection: $birthDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(PrestigeTheme.colors.cardBackground)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
        }
        .padding()
    }
}

// Education View
struct EducationView: View {
    @Binding var university: String
    @Binding var graduationYear: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingLarge) {
            VStack(alignment: .leading, spacing: 8) {
                Text("University")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                
                TextField("", text: $university)
                    .font(PrestigeTheme.fonts.systemBody)
                    .padding()
                    .background(PrestigeTheme.colors.cardBackground)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Graduation Year")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                
                TextField("", text: $graduationYear)
                    .font(PrestigeTheme.fonts.systemBody)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(PrestigeTheme.colors.cardBackground)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
        }
        .padding()
    }
}

// Career View
struct CareerView: View {
    @Binding var occupation: String
    @Binding var company: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingLarge) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Occupation")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                
                TextField("", text: $occupation)
                    .font(PrestigeTheme.fonts.systemBody)
                    .padding()
                    .background(PrestigeTheme.colors.cardBackground)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Company")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                
                TextField("", text: $company)
                    .font(PrestigeTheme.fonts.systemBody)
                    .padding()
                    .background(PrestigeTheme.colors.cardBackground)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
        }
        .padding()
    }
}

// Bio View
struct BioView: View {
    @Binding var bio: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            Text("About You")
                .font(PrestigeTheme.fonts.systemHeadline)
                .foregroundColor(PrestigeTheme.colors.primary)
            
            Text("Share a bit about yourself")
                .font(PrestigeTheme.fonts.systemCaption)
                .foregroundColor(PrestigeTheme.colors.textSecondary)
            
            TextEditor(text: $bio)
                .font(PrestigeTheme.fonts.systemBody)
                .frame(height: 150)
                .padding()
                .background(PrestigeTheme.colors.cardBackground)
                .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .padding()
    }
}

// Interests View
struct InterestsView: View {
    @Binding var selectedInterests: Set<String>
    
    let interests = [
        "Art & Culture", "Travel", "Music", "Food & Wine",
        "Finance", "Reading", "Technology", "Photography",
        "Fashion", "Sports", "Investment", "Entrepreneurship",
        "Philanthropy", "Politics", "Science", "Environment"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            Text("Interests")
                .font(PrestigeTheme.fonts.systemHeadline)
                .foregroundColor(PrestigeTheme.colors.primary)
            
            Text("Select your interests")
                .font(PrestigeTheme.fonts.systemCaption)
                .foregroundColor(PrestigeTheme.colors.textSecondary)
            
            FlowLayout(spacing: 8) {
                ForEach(interests, id: \.self) { interest in
                    InterestTag(
                        text: interest,
                        isSelected: selectedInterests.contains(interest)
                    ) {
                        if selectedInterests.contains(interest) {
                            selectedInterests.remove(interest)
                        } else {
                            selectedInterests.insert(interest)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// Interest Tag Component
struct InterestTag: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(PrestigeTheme.fonts.systemCaption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? PrestigeTheme.colors.accent : PrestigeTheme.colors.accent.opacity(0.1))
                .foregroundColor(isSelected ? .white : PrestigeTheme.colors.accent)
                .cornerRadius(16)
        }
    }
} 