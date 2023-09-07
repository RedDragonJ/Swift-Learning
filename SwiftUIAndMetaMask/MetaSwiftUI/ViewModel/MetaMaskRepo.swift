//
//  MetaMaskRepo.swift
//  MetaSwiftUI
//
//  Created by James Layton on 8/21/23.
//

import SwiftUI
import Combine
import metamask_ios_sdk

extension Notification.Name {
    static let Connection = Notification.Name("connection")
}

class MetaMaskRepo: ObservableObject {
    
    @Published var connectionStatus = "Offline" {
        didSet {
            NotificationCenter.default.post(name: .Connection, object: nil, userInfo: ["value": connectionStatus])
        }
    }
    @Published var chainID = ""
    @Published var ethAddress = ""
    
    @Published private var ethereum = MetaMaskSDK.shared.ethereum
    private let dappName = "Dub Dapp"
    private let dappUrl = "https://dubdapp.com"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        observeConnectionStatus()
    }
    
    private func observeConnectionStatus() {
        ethereum.$connected
            .sink { [weak self] isConnected in
                self?.connectionStatus = isConnected ? "Connected" : "Disconnected"
            }
            .store(in: &cancellables)
    }
    
    func connectToDapp() {
        let dapp = Dapp(name: dappName, url: dappUrl)
        ethereum.connect(dapp)?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Connection error: \(error.localizedDescription)")
                default: break
                }
            }, receiveValue: { result in
                print("Connection result: \(result)")
                DispatchQueue.main.async {
                    self.chainID = self.ethereum.chainId
                    self.ethAddress = self.ethereum.selectedAddress
                }
            })
            .store(in: &cancellables)
    }
}
