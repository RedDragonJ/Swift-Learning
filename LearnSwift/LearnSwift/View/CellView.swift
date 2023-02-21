//
//  CellView.swift
//  LearnSwift
//
//  Created by James Layton on 1/16/23.
//

import SwiftUI
import UIKit

struct CellView: View {
    
    @ObservedObject var viewModel: ViewModel
    let item: Item
    
    @State private var image: UIImage?
    
    var body: some View {
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
        .task {
            do {
                image = try await viewModel.getImage(item.imageUrl)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(viewModel: ViewModel(), item: Item(name: "", imageUrl: URL(string: "")!, type: .food, description: ""))
    }
}
