import SwiftUI

struct NotificationsSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Notification Settings
    @State private var newMatches = true
    @State private var newMessages = true
    @State private var messageReactions = true
    @State private var profileViews = true
    
    // Push Notifications
    @State private var pushEnabled = true
    @State private var emailEnabled = true
    
    // Time Settings
    @State private var quietHoursEnabled = false
    @State private var quietHoursStart = Date()
    @State private var quietHoursEnd = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: PrestigeTheme.spacing.paddingLarge) {
                    // Notification Types Section
                    SettingsSection(title: "Notification Types") {
                        ToggleSetting(
                            title: "New Matches",
                            subtitle: "When someone matches with you",
                            isOn: $newMatches
                        )
                        
                        ToggleSetting(
                            title: "New Messages",
                            subtitle: "When you receive a new message",
                            isOn: $newMessages
                        )
                        
                        ToggleSetting(
                            title: "Message Reactions",
                            subtitle: "When someone reacts to your message",
                            isOn: $messageReactions
                        )
                        
                        ToggleSetting(
                            title: "Profile Views",
                            subtitle: "When someone views your profile",
                            isOn: $profileViews
                        )
                    }
                    
                    // Delivery Methods Section
                    SettingsSection(title: "Delivery Methods") {
                        ToggleSetting(
                            title: "Push Notifications",
                            subtitle: "Receive notifications on your device",
                            isOn: $pushEnabled
                        )
                        
                        ToggleSetting(
                            title: "Email Notifications",
                            subtitle: "Receive notifications via email",
                            isOn: $emailEnabled
                        )
                    }
                    
                    // Quiet Hours Section
                    SettingsSection(title: "Quiet Hours") {
                        ToggleSetting(
                            title: "Enable Quiet Hours",
                            subtitle: "Mute notifications during specified hours",
                            isOn: $quietHoursEnabled
                        )
                        
                        if quietHoursEnabled {
                            VStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                                DatePicker(
                                    "Start Time",
                                    selection: $quietHoursStart,
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                                
                                DatePicker(
                                    "End Time",
                                    selection: $quietHoursEnd,
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                            }
                            .padding()
                        }
                    }
                    
                    // Additional Settings Section
                    SettingsSection(title: "Additional Settings") {
                        NavigationLink(destination: Text("Notification History")) {
                            SettingRow(
                                title: "Notification History",
                                subtitle: "View your recent notifications"
                            )
                        }
                        
                        NavigationLink(destination: Text("Advanced Settings")) {
                            SettingRow(
                                title: "Advanced Settings",
                                subtitle: "Configure detailed notification preferences"
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(PrestigeTheme.colors.accent))
        }
    }
}

struct NotificationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsView()
    }
} 