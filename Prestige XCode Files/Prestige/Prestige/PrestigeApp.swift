//
//  PrestigeApp.swift
//  Prestige
//
//  Created by Tripp Thomas on 5/1/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct PrestigeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var firebaseManager = FirebaseManager.shared
    @State private var isAuthenticated = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    DashboardView()
                } else {
                    AuthView()
                }
            }
            .onAppear {
                // Check if user is already logged in
                isAuthenticated = Auth.auth().currentUser != nil
            }
        }
    }
}
