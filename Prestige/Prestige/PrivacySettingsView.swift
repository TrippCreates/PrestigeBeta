import SwiftUI

struct PrivacySettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isProfileVisible = true
    @State private var showDistance = true
    @State private var showAge = true
    @State private var showOnlineStatus = true
    @State private var showReadReceipts = true
    @State private var blockList: [BlockedUser] = [
        BlockedUser(name: "John D.", university: "Yale University"),
        BlockedUser(name: "Emma S.", university: "Stanford University")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                    // Visibility Section
                    SettingsSection(title: "Visibility") {
                        ToggleSetting(
                            title: "Profile Visibility",
                            subtitle: "Show your profile in discovery",
                            isOn: $isProfileVisible
                        )
                        
                        ToggleSetting(
                            title: "Show Distance",
                            subtitle: "Allow others to see your approximate location",
                            isOn: $showDistance
                        )
                        
                        ToggleSetting(
                            title: "Show Age",
                            subtitle: "Display your age on your profile",
                            isOn: $showAge
                        )
                    }
                    
                    // Activity Status Section
                    SettingsSection(title: "Activity Status") {
                        ToggleSetting(
                            title: "Online Status",
                            subtitle: "Show when you're active",
                            isOn: $showOnlineStatus
                        )
                        
                        ToggleSetting(
                            title: "Read Receipts",
                            subtitle: "Show when you've read messages",
                            isOn: $showReadReceipts
                        )
                    }
                    
                    // Blocked Users Section
                    SettingsSection(title: "Blocked Users") {
                        ForEach(blockList) { user in
                            BlockedUserRow(user: user)
                        }
                        
                        if blockList.isEmpty {
                            Text("No blocked users")
                                .font(PrestigeTheme.fonts.systemBody)
                                .foregroundColor(PrestigeTheme.colors.textSecondary)
                                .padding()
                        }
                    }
                    
                    // Data Privacy Section
                    SettingsSection(title: "Data & Privacy") {
                        NavigationLink(destination: Text("Download Data")) {
                            SettingRow(
                                title: "Download My Data",
                                subtitle: "Get a copy of your Prestige data"
                            )
                        }
                        
                        NavigationLink(destination: Text("Delete Account")) {
                            SettingRow(
                                title: "Delete Account",
                                subtitle: "Permanently delete your account and data",
                                titleColor: PrestigeTheme.colors.secondary
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(PrestigeTheme.colors.accent))
        }
    }
}

// Models and custom views specific to PrivacySettingsView
struct BlockedUser: Identifiable {
    let id = UUID()
    let name: String
    let university: String
}

struct BlockedUserRow: View {
    let user: BlockedUser
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(PrestigeTheme.fonts.systemBody)
                    .foregroundColor(PrestigeTheme.colors.primary)
                
                Text(user.university)
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Unblock")
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.secondary)
            }
        }
        .padding()
        .background(PrestigeTheme.colors.cardBackground)
    }
}

struct PrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsView()
    }
} 