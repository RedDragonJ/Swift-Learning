//
//  CoinbaseRepo.swift
//  CoinSwiftUI
//
//

import Foundation
import CoinbaseWalletSDK

class CoinbaseRepo: ObservableObject {
    @Published var ethAddress = ""

    func connectToCoinbase() async throws {
        if !CoinbaseWalletSDK.isConfigured {
            CoinbaseWalletSDK.configure(callback: URL(string: "coinswiftui://")!)
        }

        let cbwallet = CoinbaseWalletSDK.shared
        cbwallet.resetSession()

        do {
            try await withCheckedThrowingContinuation { continuation in
                DispatchQueue.main.async {
                    cbwallet.initiateHandshake(
                        initialActions: [
                            Action(jsonRpc: .eth_requestAccounts)
                        ]
                    ) { result, account in
                        switch result {
                        case .success:
                            if let account {
                                self.ethAddress = account.address
                                continuation.resume(returning: ())
                            } else {
                                let error = NSError(domain: "error.CoinbaseSDK", code: 999, userInfo: [NSLocalizedDescriptionKey: "Coinbase wallet is not available"])
                                continuation.resume(throwing: error)
                            }

                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        } catch {
            throw error
        }
    }
}
