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
    @Published var balance = ""
    
    @Published private var ethereum = MetaMaskSDK.shared.ethereum
    private let dappName = "Dub Dapp"
    private let dappUrl = "https://dubdapp.com"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ethereum.clearSession()
        ethereum.disconnect()
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
    
    func getBalance() {
        let parameters: [String] = [ethAddress, "latest"]
        
        let getBalanceRequest = EthereumRequest(method: .ethGetBalance, params: parameters)
        
        ethereum.request(getBalanceRequest)?.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("Failed to get balance, \(error.localizedDescription)")
            default: break
            }
        }, receiveValue: { result in
            DispatchQueue.main.async {
                let ethInHexForm = result as? String ?? ""
                self.balance = "\(self.convertHexIntoDecimal(hex: ethInHexForm)) ETH"
            }
        })
        .store(in: &cancellables)
    }
    
    func convertHexIntoDecimal(hex: String) -> String {
        let scanner = Scanner(string: hex)
        var hexInt: UInt64 = 0
        scanner.scanHexInt64(&hexInt)
        var etherDecimal = Decimal(hexInt) / pow(10, 18)
        var roundedEtherDecimal = Decimal()
        NSDecimalRound(&roundedEtherDecimal, &etherDecimal, 5, .up)
        return roundedEtherDecimal.description
    }
}
