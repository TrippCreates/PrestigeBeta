import SwiftUI

struct VerificationPage: View {
    @State private var email: String = ""
    @State private var submissionStatus: String = ""
    @State private var isCheckingStatus: Bool = false
    @State private var showUniversityList = false
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        ZStack {
            PrestigeTheme.colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                    // Header
                    VStack(spacing: PrestigeTheme.spacing.paddingSmall) {
                        Text("Join Prestige")
                            .font(PrestigeTheme.fonts.systemTitle)
                            .foregroundColor(PrestigeTheme.colors.primary)
                        
                        Text("Verify your university email")
                            .font(PrestigeTheme.fonts.systemBody)
                            .foregroundColor(PrestigeTheme.colors.textSecondary)
                    }
                    .padding(.top, PrestigeTheme.spacing.paddingLarge)
                    
                    // Email Input Card
                    VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                        TextField("Enter your .edu email", text: $email)
                            .font(PrestigeTheme.fonts.systemBody)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disabled(isCheckingStatus)
                            .padding(.horizontal)
                        
                        Button(action: {
                            showUniversityList.toggle()
                        }) {
                            HStack {
                                Image(systemName: "building.columns")
                                Text("View Eligible Universities")
                            }
                            .font(PrestigeTheme.fonts.systemCaption)
                            .foregroundColor(PrestigeTheme.colors.accent)
                        }
                    }
                    .padding()
                    .background(PrestigeTheme.colors.cardBackground)
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    if !isCheckingStatus {
                        Button(action: submitEmail) {
                            PrestigeTheme.buttonStyle.primaryButton(title: "Send Verification Email")
                        }
                        .padding(.horizontal)
                    } else {
                        // Verification Status Card
                        VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                            Image(systemName: "envelope.open.fill")
                                .font(.system(size: 40))
                                .foregroundColor(PrestigeTheme.colors.accent)
                            
                            Text("Verification email sent!")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            
                            Text("Please check your inbox and click the verification link.")
                                .font(PrestigeTheme.fonts.systemBody)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: checkVerificationStatus) {
                                PrestigeTheme.buttonStyle.secondaryButton(title: "Check Verification Status")
                            }
                            
                            Button(action: resetForm) {
                                Text("Verify Different Email")
                                    .font(PrestigeTheme.fonts.systemCaption)
                                    .foregroundColor(PrestigeTheme.colors.accent)
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(PrestigeTheme.colors.cardBackground)
                        .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                    
                    if !submissionStatus.isEmpty {
                        Text(submissionStatus)
                            .font(PrestigeTheme.fonts.systemBody)
                            .foregroundColor(submissionStatus.contains("Error") || submissionStatus.contains("not eligible") ? 
                                PrestigeTheme.colors.secondary : PrestigeTheme.colors.sage)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showUniversityList) {
            UniversityListView()
        }
    }
    
    func submitEmail() {
        guard !email.isEmpty else {
            submissionStatus = "Please enter an email address"
            return
        }
        
        guard email.contains("@") else {
            submissionStatus = "Please enter a valid email address"
            return
        }
        
        // Check if the email is from an approved university
        let validationResult = UniversityValidator.shared.isValidUniversityEmail(email)
        guard validationResult.isValid else {
            submissionStatus = "This email is not eligible. Please use an email from an approved university."
            return
        }
        
        firebaseManager.createUserAndSendVerification(email: email) { success, message in
            DispatchQueue.main.async {
                if success {
                    submissionStatus = "Verification email sent to \(validationResult.universityName ?? "your university") email!"
                    isCheckingStatus = true
                } else {
                    submissionStatus = message
                }
            }
        }
    }
    
    func checkVerificationStatus() {
        firebaseManager.checkEmailVerificationStatus(email: email) { isVerified in
            DispatchQueue.main.async {
                if isVerified {
                    submissionStatus = "Email verified successfully!"
                    // Store the university information
                    if let university = UniversityValidator.shared.getUniversityInfo(for: email) {
                        // You can use this information to update the user's profile
                        print("Verified email from \(university.name) (Rank: \(university.rank))")
                    }
                } else {
                    submissionStatus = "Email not verified yet. Please check your inbox and click the verification link."
                }
            }
        }
    }
    
    func resetForm() {
        email = ""
        submissionStatus = ""
        isCheckingStatus = false
    }
}

struct UniversityListView: View {
    let universities = UniversityValidator.shared.getAllUniversities()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                PrestigeTheme.colors.background
                    .ignoresSafeArea()
                
                List {
                    ForEach(universities, id: \.name) { university in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(university.name)
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .foregroundColor(PrestigeTheme.colors.accent)
                                Text("Rank: #\(university.rank)")
                                    .font(PrestigeTheme.fonts.systemCaption)
                                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Eligible Universities")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(PrestigeTheme.colors.accent))
        }
    }
}
