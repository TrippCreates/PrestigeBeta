import SwiftUI

struct TermsAndConditionsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingLarge) {
                    // Terms Section
                    SettingsSection(title: "Terms of Service") {
                        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                            Text("1. Eligibility")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            Text("Prestige is exclusively available to verified students and alumni of top universities. Users must provide and verify their .edu email address to access the platform.")
                                .font(PrestigeTheme.fonts.systemBody)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                            
                            Text("2. User Conduct")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                                .padding(.top)
                            Text("Users must maintain respectful and professional behavior. Any form of harassment, discrimination, or inappropriate content will result in immediate account termination.")
                                .font(PrestigeTheme.fonts.systemBody)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                            
                            Text("3. Privacy")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                                .padding(.top)
                            Text("We prioritize user privacy and data protection. Personal information is handled according to our Privacy Policy and applicable data protection laws.")
                                .font(PrestigeTheme.fonts.systemBody)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                        }
                        .padding()
                    }
                    
                    // Privacy Policy Section
                    SettingsSection(title: "Privacy Policy") {
                        VStack(alignment: .leading, spacing: PrestigeTheme.spacing.paddingMedium) {
                            Text("Data Collection")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            Text("We collect and process personal information necessary for providing our services, including but not limited to educational verification, profile information, and user interactions.")
                                .font(PrestigeTheme.fonts.systemBody)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                            
                            Text("Data Usage")
                                .font(PrestigeTheme.fonts.systemHeadline)
                                .foregroundColor(PrestigeTheme.colors.primary)
                                .padding(.top)
                            Text("Your data is used to enhance user experience, improve our services, and ensure platform security. We do not sell personal information to third parties.")
                                .font(PrestigeTheme.fonts.systemBody)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Terms & Privacy")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(PrestigeTheme.colors.accent))
        }
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
} 