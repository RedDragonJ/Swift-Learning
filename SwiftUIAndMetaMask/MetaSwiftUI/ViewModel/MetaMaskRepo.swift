//
//  MetaMaskRepo.swift
//  MetaSwiftUI
//
//  Created by James Layton on 8/21/23.
//

import SwiftUI
import metamask_ios_sdk

class MetaMaskRepo: ObservableObject {
    
    @ObservedObject var ethereum = MetaMaskSDK.shared.ethereum

    private let dappName = "MetaMask"
    private let dappUrl = "https://metamask.io/"
    
    func connectToDapp() {
        let dapp = Dapp(name: dappName, url: dappUrl)
        // This is the same as calling eth_requestAccounts
        ethereum.connect(dapp)
    }
}
