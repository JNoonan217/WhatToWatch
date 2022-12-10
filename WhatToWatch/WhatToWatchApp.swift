//
//  WhatToWatchApp.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct WhatToWatchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var showsVM = ShowsViewModel()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(showsVM)
        }
    }
}
