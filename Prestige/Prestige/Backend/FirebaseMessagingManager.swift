import Foundation
import FirebaseCore
import FirebaseMessaging
import UserNotifications

// MARK: - Message Structure

struct ChatMessage: Codable {
    let messageId: String
    let senderId: String
    let receiverId: String
    let content: String
    let timestamp: Date
    let type: MessageType
    
    enum MessageType: String, Codable {
        case text
        case image
        case video
        case audio
        case location
    }
}

class FirebaseMessagingManager: NSObject {
    static let shared = FirebaseMessagingManager()
    
    private var currentUserId: String?
    private var messageHandlers: [(ChatMessage) -> Void] = []
    
    private override init() {
        super.init()
        setupFirebaseMessaging()
    }
    
    // MARK: - User Management
    
    func setCurrentUser(_ userId: String) {
        self.currentUserId = userId
        // Subscribe to user's personal topic
        subscribeToTopic("user_\(userId)") { error in
            if let error = error {
                print("Error subscribing to user topic: \(error)")
            }
        }
    }
    
    func clearCurrentUser() {
        if let userId = currentUserId {
            unsubscribeFromTopic("user_\(userId)") { _ in }
        }
        self.currentUserId = nil
    }
    
    // MARK: - Message Handling
    
    func addMessageHandler(_ handler: @escaping (ChatMessage) -> Void) {
        messageHandlers.append(handler)
    }
    
    func removeMessageHandler(_ handler: @escaping (ChatMessage) -> Void) {
        messageHandlers.removeAll { $0 as AnyObject === handler as AnyObject }
    }
    
    private func handleIncomingMessage(_ userInfo: [AnyHashable: Any]) {
        guard let messageData = userInfo["message"] as? [String: Any],
              let messageId = messageData["messageId"] as? String,
              let senderId = messageData["senderId"] as? String,
              let receiverId = messageData["receiverId"] as? String,
              let content = messageData["content"] as? String,
              let timestamp = messageData["timestamp"] as? TimeInterval,
              let typeString = messageData["type"] as? String,
              let type = ChatMessage.MessageType(rawValue: typeString) else {
            print("Invalid message format")
            return
        }
        
        let message = ChatMessage(
            messageId: messageId,
            senderId: senderId,
            receiverId: receiverId,
            content: content,
            timestamp: Date(timeIntervalSince1970: timestamp),
            type: type
        )
        
        // Notify all handlers
        messageHandlers.forEach { $0(message) }
    }
    
    // MARK: - Message Sending
    
    func sendMessage(_ message: ChatMessage, completion: @escaping (Error?) -> Void) {
        guard let currentUserId = currentUserId else {
            completion(NSError(domain: "FirebaseMessaging", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user set"]))
            return
        }
        
        // Create message payload
        let messageData: [String: Any] = [
            "messageId": message.messageId,
            "senderId": message.senderId,
            "receiverId": message.receiverId,
            "content": message.content,
            "timestamp": message.timestamp.timeIntervalSince1970,
            "type": message.type.rawValue
        ]
        
        // Send to both sender and receiver topics
        let topics = ["user_\(message.senderId)", "user_\(message.receiverId)"]
        
        // In a real app, you would send this to your backend server
        // which would then use Firebase Admin SDK to send the message
        print("Sending message to topics: \(topics)")
        print("Message data: \(messageData)")
        
        // For now, we'll just simulate success
        completion(nil)
    }
    
    // MARK: - Setup
    
    private func setupFirebaseMessaging() {
        // Set up Firebase Messaging delegate
        Messaging.messaging().delegate = self
        
        // Request authorization for notifications
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // Register for remote notifications
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    // MARK: - Token Management
    
    func getFCMToken(completion: @escaping (String?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                completion(nil)
            } else if let token = token {
                print("FCM registration token: \(token)")
                completion(token)
            }
        }
    }
    
    // MARK: - Topic Subscription
    
    func subscribeToTopic(_ topic: String, completion: @escaping (Error?) -> Void) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                print("Error subscribing to topic: \(error)")
                completion(error)
            } else {
                print("Subscribed to topic: \(topic)")
                completion(nil)
            }
        }
    }
    
    func unsubscribeFromTopic(_ topic: String, completion: @escaping (Error?) -> Void) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                print("Error unsubscribing from topic: \(error)")
                completion(error)
            } else {
                print("Unsubscribed from topic: \(topic)")
                completion(nil)
            }
        }
    }
}

// MARK: - MessagingDelegate

extension FirebaseMessagingManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        // Notify about token refresh
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension FirebaseMessagingManager: UNUserNotificationCenterDelegate {
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Handle incoming message
        handleIncomingMessage(userInfo)
        
        // Show notification even when app is in foreground
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // Handle notification when app is in background and user taps on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle incoming message
        handleIncomingMessage(userInfo)
        
        completionHandler()
    }
} 