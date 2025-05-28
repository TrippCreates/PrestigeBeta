import SwiftUI

struct UserProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showEditProfile = false
    @State private var showTerms = false  // Add state for terms sheet
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                    // Profile Header
                    VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                        // Profile Image
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
                        
                        // Profile Info
                        VStack(spacing: PrestigeTheme.spacing.paddingSmall) {
                            Text("Sarah Johnson")
                                .font(PrestigeTheme.fonts.systemTitle)
                                .foregroundColor(PrestigeTheme.colors.primary)
                            
                            HStack {
                                Image(systemName: "building.columns.fill")
                                Text("Harvard University")
                            }
                            .font(PrestigeTheme.fonts.systemBody)
                            .foregroundColor(PrestigeTheme.colors.accent)
                            
                            Text("Class of 2022")
                                .font(PrestigeTheme.fonts.systemCaption)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                        }
                    }
                    
                    // Settings Sections
                    VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                        // Edit Profile Section
                        SettingsSection(title: "Profile") {
                            NavigationLink(destination: EditProfileView()) {
                                SettingRow(
                                    title: "Edit Profile",
                                    subtitle: "Update your photos and information"
                                )
                            }
                            
                            NavigationLink(destination: VerificationPage()) {
                                SettingRow(
                                    title: "Verification",
                                    subtitle: "Verify your profile details"
                                )
                            }
                        }
                        
                        // Privacy Section
                        SettingsSection(title: "Privacy") {
                            NavigationLink(destination: PrivacySettingsView()) {
                                SettingRow(
                                    title: "Privacy Settings",
                                    subtitle: "Manage your privacy preferences"
                                )
                            }
                        }
                        
                        // Notifications Section
                        SettingsSection(title: "Notifications") {
                            NavigationLink(destination: NotificationsSettingsView()) {
                                SettingRow(
                                    title: "Notification Preferences",
                                    subtitle: "Customize your notifications"
                                )
                            }
                        }
                        
                        // Support Section
                        SettingsSection(title: "Support") {
                            Button(action: {
                                // Add support action
                            }) {
                                SettingRow(
                                    title: "Help & Support",
                                    subtitle: "Get help and contact support"
                                )
                            }
                            
                            Button(action: {
                                showTerms = true
                            }) {
                                SettingRow(
                                    title: "Terms & Privacy Policy",
                                    subtitle: "Read our terms and policies"
                                )
                            }
                        }
                        
                        // Account Section
                        SettingsSection(title: "Account") {
                            Button(action: {
                                // Add logout action
                            }) {
                                SettingRow(
                                    title: "Log Out",
                                    subtitle: "Sign out of your account"
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(PrestigeTheme.colors.accent)
            )
            .sheet(isPresented: $showTerms) {
                TermsAndConditionsView()
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
} 
