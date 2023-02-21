//
//  ContentView.swift
//  LearnSwift
//
//  Created by James Layton on 1/4/23.
//

import SwiftUI

struct ContentView: View {
    
    private let api = "https://raw.githubusercontent.com/RedDragonJ/Swift-Learning/main/LearnSwift/SampleServerFiles/items.json"
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.items, id: \.self) { item in
                
                ZStack(alignment: .leading) {
                    NavigationLink {
                        ContentDetail(item: item)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    CellView(viewModel: viewModel, item: item)
                }
            }
            .navigationTitle("Food List")
            .task {
                do {
                    try await viewModel.getAPIData(urlString: api)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
