//
//  AuthenticationApp.swift
//  Authentication
//
//  Created by Mark on 1/29/23.
//

import SwiftUI
import FirebaseCore


@main
struct AuthenticationApp: App {
    
    @StateObject var user = User()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
        }
    }
}
