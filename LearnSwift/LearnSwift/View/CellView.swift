//
//  CellView.swift
//  LearnSwift
//
//  Created by James Layton on 1/16/23.
//

import SwiftUI
import UIKit

struct CellView: View {
    
    @State private var showAlert = false
    @State private var alertDetail: AlertDetail?
    @State private var showProgressView = false
    
    @ObservedObject var viewModel: ViewModel
    let item: Item
    
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            HStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.white, lineWidth: 4)
                        }
                        .shadow(radius: 7)
                }
                    
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.description)
                        .lineLimit(1)
                        .font(.caption)
                }
            }
            .alert(with: $showAlert, alertDetails: $alertDetail)
            .task {
                do {
                    showProgressView = true
                    image = try await viewModel.getImage(item.imageUrl)
                    showProgressView = false
                } catch let error {
                    showProgressView = false
                    showAlert(AlertDetail(title: "Error", message: error.localizedDescription))
                }
            }
            
            CustomProgress(isVisible: showProgressView)
        }
    }
    
    func showAlert(_ alertDetail: AlertDetail) {
        showAlert.toggle()
        self.alertDetail = alertDetail
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(viewModel: ViewModel(), item: Item(name: "", imageUrl: URL(string: "")!, type: .food, description: ""))
    }
}
