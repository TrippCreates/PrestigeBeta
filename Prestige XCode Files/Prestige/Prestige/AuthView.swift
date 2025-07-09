import SwiftUI
import FirebaseAuth

struct AuthView: View {
    @StateObject private var firebaseManager = FirebaseManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showVerificationAlert = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isAuthenticated = false
    
    var body: some View {
        NavigationView {
            ZStack {
                PrestigeTheme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                        // Logo and Branding
                        VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                            Text("PRESTIGE")
                                .font(PrestigeTheme.fonts.systemLargeTitle)
                                .foregroundColor(PrestigeTheme.colors.primary)
                                .tracking(8)
                            
                            Text(isSignUp ? "Create Your Account" : "Welcome Back")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.secondary)
                                .tracking(2)
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                        
                        // Email Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(PrestigeTheme.fonts.systemCaption)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(PrestigeTheme.colors.cardBackground)
                                .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                        }
                        .padding(.horizontal)
                        
                        // Password Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(PrestigeTheme.fonts.systemCaption)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(PrestigeTheme.colors.cardBackground)
                                .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                        }
                        .padding(.horizontal)
                        
                        // Error message
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(PrestigeTheme.fonts.systemCaption)
                                .foregroundColor(PrestigeTheme.colors.secondary)
                                .padding(.top, 4)
                        }
                        
                        // Sign Up/Login Button
                        Button(action: {
                            if isSignUp {
                                signUp()
                            } else {
                                signIn()
                            }
                        }) {
                            Text(isSignUp ? "Create Account" : "Login")
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
                        .padding(.horizontal)
                        
                        // Toggle between Sign Up and Login
                        Button(action: {
                            isSignUp.toggle()
                            errorMessage = ""
                        }) {
                            Text(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up")
                                .font(PrestigeTheme.fonts.systemCaption)
                                .foregroundColor(PrestigeTheme.colors.accent)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Verification Required", isPresented: $showVerificationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please check your email for a verification link. You'll need to verify your email before you can use the app.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func signUp() {
        guard !email.isEmpty else {
            errorMessage = "Please enter an email address"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter a password"
            return
        }
        
        firebaseManager.createUserAndSendVerification(email: email, password: password) { success, message in
            if success {
                showVerificationAlert = true
            } else {
                errorMessage = message
                showError = true
            }
        }
    }
    
    private func signIn() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return
        }
        
        firebaseManager.signIn(email: email, password: password) { success, message in
            if success {
                isAuthenticated = true
            } else {
                errorMessage = message
                showError = true
            }
        }
    }
} 