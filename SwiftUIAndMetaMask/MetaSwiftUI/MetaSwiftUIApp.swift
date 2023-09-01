//
//  MetaSwiftUIApp.swift
//  MetaSwiftUI
//
//  Created by James Layton on 8/21/23.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle the URL here
        print(url)
        return true
    }
}

@main
struct MetaSwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
