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
            ZStack {
                PrestigeTheme.colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress Bar
                    ProgressBar(currentStep: currentStep, totalSteps: steps.count)
                        .padding(.top)
                    
                    // Step Title
                    Text(steps[currentStep])
                        .font(PrestigeTheme.fonts.systemTitle)
                        .foregroundColor(PrestigeTheme.colors.primary)
                        .padding(.vertical)
                    
                    // Step Content
                    ScrollView {
                        VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                            switch currentStep {
                            case 0:
                                PhotoSelectionView(photos: $photos, selectedIndex: $selectedPhotoIndex, showImagePicker: $showImagePicker)
                            case 1:
                                BasicInfoView(firstName: $firstName, birthDate: $birthDate)
                            case 2:
                                EducationView(university: $university, graduationYear: $graduationYear)
                            case 3:
                                CareerView(occupation: $occupation, company: $company)
                            case 4:
                                BioView(bio: $bio)
                            case 5:
                                InterestsView(selectedInterests: $selectedInterests)
                            default:
                                EmptyView()
                            }
                        }
                        .padding()
                    }
                    
                    // Navigation Buttons
                    HStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                        if currentStep > 0 {
                            Button(action: { currentStep -= 1 }) {
                                Text("Back")
                                    .font(PrestigeTheme.fonts.systemHeadline)
                                    .foregroundColor(PrestigeTheme.colors.secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(PrestigeTheme.colors.cardBackground)
                                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            }
                        }
                        
                        Button(action: {
                            if currentStep < steps.count - 1 {
                                currentStep += 1
                            } else {
                                // Submit profile
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text(currentStep == steps.count - 1 ? "Complete" : "Next")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            PrestigeTheme.colors.secondary,
                                            PrestigeTheme.colors.accent
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                if let selectedIndex = selectedPhotoIndex {
                    ImagePicker(image: $photos[selectedIndex])
                }
            }
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
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
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PrestigeTheme.colors.secondary,
                                PrestigeTheme.colors.accent
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps), height: 4)
            }
        }
        .frame(height: 4)
    }
}

// Photo Selection View
struct PhotoSelectionView: View {
    @Binding var photos: [UIImage?]
    @Binding var selectedIndex: Int?
    @Binding var showImagePicker: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            Text("Add your best photos")
                .font(PrestigeTheme.fonts.systemHeadline)
                .foregroundColor(PrestigeTheme.colors.primary)
            
            Text("First photo will be your profile picture")
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
    }
}

// Interests View
struct InterestsView: View {
    @Binding var selectedInterests: Set<String>
    
    let interests = [
        "Art & Culture", "Travel", "Music", "Food & Wine",
        "Fitness", "Reading", "Technology", "Photography",
        "Fashion", "Sports", "Investment", "Entrepreneurship",
        "Philanthropy", "Politics", "Science", "Environment"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
            Text("Select Your Interests")
                .font(PrestigeTheme.fonts.systemHeadline)
                .foregroundColor(PrestigeTheme.colors.primary)
            
            Text("Choose up to 8 interests")
                .font(PrestigeTheme.fonts.systemCaption)
                .foregroundColor(PrestigeTheme.colors.textSecondary)
            
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
    }
}

// Interest Tag Component
struct InterestTag: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(PrestigeTheme.fonts.systemCaption)
                .foregroundColor(isSelected ? .white : PrestigeTheme.colors.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PrestigeTheme.colors.secondary,
                                PrestigeTheme.colors.accent
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PrestigeTheme.colors.cardBackground,
                                PrestigeTheme.colors.cardBackground
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ? Color.clear : PrestigeTheme.colors.border,
                            lineWidth: 1
                        )
                )
        }
    }
}

// Flow Layout for Interests
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth {
                currentX = 0
                currentY += currentRowHeight + spacing
                currentRowHeight = 0
            }
            
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
        
        height = currentY + currentRowHeight
        
        return CGSize(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += currentRowHeight + spacing
                currentRowHeight = 0
            }
            
            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(size)
            )
            
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
} 