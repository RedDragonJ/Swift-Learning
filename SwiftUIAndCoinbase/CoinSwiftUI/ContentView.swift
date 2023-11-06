//
//  ContentView.swift
//  CoinSwiftUI
//
//

import SwiftUI

struct ContentView: View {

    @StateObject private var coinbaseRepo = CoinbaseRepo()

    var body: some View {
        VStack {
            Text("Wallet address")
            Text(coinbaseRepo.ethAddress)

            Button {
                Task {
                    try await coinbaseRepo.connectToCoinbase()
                }
            } label: {
                Text("Connect to Coinbase Wallet")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
