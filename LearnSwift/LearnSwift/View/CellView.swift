//
//  CellView.swift
//  LearnSwift
//
//  Created by James Layton on 1/16/23.
//

import SwiftUI

struct CellView: View {
    
    let item: Item
    
    var body: some View {
        HStack {
            AsyncImage(url: item.imageUrl) { image in
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white, lineWidth: 4)
                    }
                    .shadow(radius: 7)
                
            } placeholder: {
                // Do nothing
            }
                
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.description)
                    .lineLimit(1)
                    .font(.caption)
            }
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(item: Item(name: "", imageUrl: URL(string: "")!, type: .food, description: ""))
    }
}
