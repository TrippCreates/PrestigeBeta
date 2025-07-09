import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isFromCurrentUser: Bool
    let timestamp: Date
}

struct ChatView: View {
    let matchName: String
    let matchUniversity: String
    @State private var messageText: String = ""
    @State private var messages: [Message] = [
        Message(content: "Hi there! I saw we both studied Economics!", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600)),
        Message(content: "Yes! Are you working in finance now?", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3500)),
        Message(content: "I'm at Goldman Sachs. How about you?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3400))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat Header
            VStack(spacing: 4) {
                Text(matchName)
                    .font(PrestigeTheme.fonts.systemHeadline)
                    .foregroundColor(PrestigeTheme.colors.primary)
                
                HStack {
                    Text(matchUniversity)
                        .font(PrestigeTheme.fonts.systemCaption)
                        .foregroundColor(PrestigeTheme.colors.textSecondary)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(PrestigeTheme.colors.sage)
                        .font(.system(size: 12))
                }
            }
            .padding()
            .background(PrestigeTheme.colors.cardBackground)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Messages
            ScrollView {
                LazyVStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Message Input
            VStack(spacing: 0) {
                Divider()
                    .background(PrestigeTheme.colors.border)
                
                HStack(spacing: PrestigeTheme.spacing.paddingMedium) {
                    TextField("Type a message...", text: $messageText)
                        .padding()
                        .background(PrestigeTheme.colors.cardBackground)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(PrestigeTheme.colors.border, lineWidth: 1)
                        )
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(messageText.isEmpty ? 
                                PrestigeTheme.colors.textSecondary : 
                                PrestigeTheme.colors.accent)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding()
                .background(PrestigeTheme.colors.background)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let newMessage = Message(
            content: messageText,
            isFromCurrentUser: true,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer() }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(PrestigeTheme.fonts.systemBody)
                    .foregroundColor(message.isFromCurrentUser ? .white : PrestigeTheme.colors.primary)
                    .padding()
                    .background(
                        message.isFromCurrentUser ?
                            PrestigeTheme.colors.accent :
                            PrestigeTheme.colors.cardBackground
                    )
                    .cornerRadius(PrestigeTheme.spacing.cornerRadius)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                Text(formatTimestamp(message.timestamp))
                    .font(PrestigeTheme.fonts.systemCaption)
                    .foregroundColor(PrestigeTheme.colors.textSecondary)
            }
            
            if !message.isFromCurrentUser { Spacer() }
        }
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(matchName: "Alexandra", matchUniversity: "Stanford University")
        }
    }
} 