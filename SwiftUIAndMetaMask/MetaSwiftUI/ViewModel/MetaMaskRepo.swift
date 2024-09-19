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

// REMINDER: Use latest Metamask iOS SDK https://github.com/MetaMask/metamask-ios-sdk/releases
//extension MetaMaskRepo {
//    func connectToMetaMaskV2() async throws {
//        let appMetadata = AppMetadata(name: dappName, url: dappUrl)
//        metaMaskSDK = .shared(appMetadata, sdkOptions: nil)
//
//        do {
//            let result = await metaMaskSDK?.connect()
//            switch result {
//            case .success(let accounts):
//                MLog.logEvent(with: K.EventName.metaMaskWalletConnection)
//
//                if let jsonData = accounts.data(using: .utf8),
//                   let jsonArray = try? JSONDecoder().decode([String].self, from: jsonData),
//                   let ethAddress = jsonArray.first {
//                    DispatchQueue.main.async {
//                        self.saveWalletAddress(ethAddress)
//                    }
//                } else {
//                    let error = NSError(domain: K.InvalidState.domain,
//                                        code: K.InvalidState.code,
//                                        userInfo: [NSLocalizedDescriptionKey: "Failed to parse MetaMask address data."])
//                    MLog.logError(.network, error: error)
//                    throw error
//                }
//
//            case .failure(let error):
//                MLog.logError(.network, error: error)
//                throw error
//            case .none:
//                DispatchQueue.main.async {
//                    self.saveWalletAddress(nil)
//                }
//            }
//            disconnectFromMetaMask()
//        } catch {
//            disconnectFromMetaMask()
//            MLog.logError(.network, error: error)
//            throw error
//        }
//    }
//}
