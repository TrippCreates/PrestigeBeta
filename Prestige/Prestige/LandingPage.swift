import SwiftUI

// Main structure for the landing page
struct LandingPage: View {
    @State private var isGetVerifiedPressed = false  // Track if Get Verified button is pressed
    @State private var isLoginPressed = false  // Track if Login button is pressed

    var body: some View {
        NavigationView {
            ZStack {
                // Background
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
                            
                            Text("Where Excellence Meets")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.secondary)
                                .tracking(2)
                        }
                        .padding(.top, 60)
                        
                        // Main Content
                        VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                            // Action Buttons
                            VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                                NavigationLink(destination: VerificationPage()) {
                                    PrestigeTheme.buttonStyle.primaryButton(title: "Get Verified")
                                        .scaleEffect(isGetVerifiedPressed ? 0.95 : 1.0)
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isGetVerifiedPressed = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            isGetVerifiedPressed = false
                                        }
                                    }
                                })
                                
                                NavigationLink(destination: LoginPage()) {
                                    PrestigeTheme.buttonStyle.secondaryButton(title: "Login")
                                        .scaleEffect(isLoginPressed ? 0.95 : 1.0)
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isLoginPressed = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            isLoginPressed = false
                                        }
                                    }
                                })
                            }
                            .padding(.horizontal, PrestigeTheme.spacing.paddingLarge)
                            
                            // Feature Cards
                            VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                                FeatureCard(
                                    icon: "checkmark.seal.fill",
                                    title: "Verified Members",
                                    description: "Exclusively curated from top schools and elite companies"
                                )
                                
                                FeatureCard(
                                    icon: "star.fill",
                                    title: "Meet Exceptional People",
                                    description: "Connect with high-achieving individuals who share your ambition"
                                )
                                
                                FeatureCard(
                                    icon: "lock.fill",
                                    title: "Private & Secure",
                                    description: "Your privacy is our priority"
                                )
                            }
                            .padding(.horizontal, PrestigeTheme.spacing.paddingMedium)
                        }
                    }
                }
            }
        }
    }
}

// Modern Feature Card
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: PrestigeTheme.spacing.paddingMedium) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PrestigeTheme.colors.secondary.opacity(0.1),
                                PrestigeTheme.colors.accent.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(PrestigeTheme.colors.accent)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(PrestigeTheme.fonts.systemHeadline)
                    .foregroundColor(PrestigeTheme.colors.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 20)
                
                Text(description)
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 35)
            }
            Spacer()
        }
        .frame(height: 80)
        .padding(.horizontal, PrestigeTheme.spacing.paddingMedium)
        .padding(.vertical, PrestigeTheme.spacing.paddingSmall)
        .background(
            RoundedRectangle(cornerRadius: PrestigeTheme.spacing.cornerRadius)
                .fill(PrestigeTheme.colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: PrestigeTheme.spacing.cornerRadius)
                        .stroke(PrestigeTheme.colors.accent.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
}

// Preview provider to show the landing page in Xcode's preview
struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
