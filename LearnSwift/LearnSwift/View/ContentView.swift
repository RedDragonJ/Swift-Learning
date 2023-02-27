//
//  ContentView.swift
//  LearnSwift
//
//  Created by James Layton on 1/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showAlert = false
    @State private var alertDetail: AlertDetail?
    @State private var showProgressView = false
    
    private let api = "https://raw.githubusercontent.com/RedDragonJ/Swift-Learning/main/LearnSwift/SampleServerFiles/items.json"
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
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
                        showProgressView = true
                        try await viewModel.getAPIData(urlString: api)
                        showProgressView = false
                    } catch let error {
                        showProgressView = false
                        showAlert(AlertDetail(title: "Error", message: error.localizedDescription))
                    }
                }
            }
            .alert(with: $showAlert, alertDetails: $alertDetail)
            
            CustomProgress(isVisible: showProgressView)
        }
    }
    
    func showAlert(_ alertDetail: AlertDetail) {
        showAlert.toggle()
        self.alertDetail = alertDetail
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
