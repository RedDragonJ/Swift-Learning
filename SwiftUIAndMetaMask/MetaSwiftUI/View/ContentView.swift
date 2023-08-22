//
//  ContentView.swift
//  MetaSwiftUI
//
//  Created by James Layton on 8/21/23. 
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var metaMaskRepo = MetaMaskRepo()
    
    var body: some View {
        VStack {
            Text("MetaSwiftUI")
                .font(.title)
            
            Text(metaMaskRepo.ethereum.selectedAddress)
                .fontWeight(.bold)
            
            Button {
                metaMaskRepo.connectToDapp()
            } label: {
                Text("Connect to MetaMask")
                    .frame(width: 300, height: 50)
                    .border(.black)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
