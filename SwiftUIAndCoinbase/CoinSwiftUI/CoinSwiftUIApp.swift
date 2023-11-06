//
//  CoinSwiftUIApp.swift
//  CoinSwiftUI
//
//

import SwiftUI
import CoinbaseWalletSDK

@main
struct CoinSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    print("Reveived ULR \(url.absoluteString)")
                    // Handle different type of URL
                    _ = try? CoinbaseWalletSDK.shared.handleResponse(url)
                })
        }
    }
}
