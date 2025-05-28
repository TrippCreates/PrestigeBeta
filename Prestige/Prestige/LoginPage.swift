import SwiftUI

// MARK: - Remove this constant before production
let SHOW_ADMIN_LOGIN = true

struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    @State private var navigateToHome = false
    @State private var adminNavigateToHome = false  // For admin quick access

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                PrestigeTheme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        // Logo and Branding
                        VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                            Text("PRESTIGE")
                                .font(PrestigeTheme.fonts.systemLargeTitle)
                                .foregroundColor(PrestigeTheme.colors.primary)
                                .tracking(8)
                            
                            Text("Welcome Back")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.secondary)
                                .tracking(2)
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                        
                        // Login Form
                        VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                            // Email field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(PrestigeTheme.fonts.systemCaption)
                                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                                
                                TextField("", text: $email)
                                    .font(PrestigeTheme.fonts.systemBody)
                                    .foregroundColor(PrestigeTheme.colors.primary)
                                    .padding()
                                    .background(PrestigeTheme.colors.cardBackground)
                                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            
                            // Password field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(PrestigeTheme.fonts.systemCaption)
                                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                                
                                SecureField("", text: $password)
                                    .font(PrestigeTheme.fonts.systemBody)
                                    .foregroundColor(PrestigeTheme.colors.primary)
                                    .padding()
                                    .background(PrestigeTheme.colors.cardBackground)
                                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            }
                            
                            // Error message
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .font(PrestigeTheme.fonts.systemCaption)
                                    .foregroundColor(PrestigeTheme.colors.secondary)
                                    .padding(.top, 4)
                            }
                            
                            // Login button
                            Button(action: {
                                loginUser()
                            }) {
                                Text("Login")
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
                            
                            // MARK: - Development Only - Remove before production
                            if SHOW_ADMIN_LOGIN {
                                Button(action: {
                                    adminNavigateToHome = true
                                }) {
                                    Text("Quick Access (Dev Only)")
                                        .font(PrestigeTheme.fonts.systemCaption)
                                        .foregroundColor(PrestigeTheme.colors.textSecondary)
                                        .padding(.vertical, 8)
                                }
                            }
                            
                            Spacer()
                            
                            // Register link
                            HStack {
                                Text("Don't have an account?")
                                    .font(PrestigeTheme.fonts.systemCaption)
                                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                                
                                NavigationLink("Get Verified", destination: VerificationPage())
                                    .font(PrestigeTheme.fonts.systemCaption)
                                    .foregroundColor(PrestigeTheme.colors.accent)
                            }
                            .padding(.vertical, PrestigeTheme.spacing.paddingLarge)
                        }
                        .padding(.horizontal, PrestigeTheme.spacing.paddingLarge)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomePage()
            }
            .navigationDestination(isPresented: $adminNavigateToHome) {
                HomePage()
            }
        }
    }

    private func loginUser() {
        // Add your login logic here
        // For now, just navigate to home
        navigateToHome = true
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}



