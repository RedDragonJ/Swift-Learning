//
//  ContentDetail.swift
//  LearnSwift
//
//  Created by James Layton on 1/22/23.
//

import SwiftUI

struct ContentDetail: View {
    
    let item: Item
        
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: item.imageUrl) { image in
                image
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.white, lineWidth: 4)
                    }
                    .shadow(radius: 7)

            } placeholder: {
                // Do nothing
            }
            
            Text(item.name)
                .font(.title)
            Text(item.type.rawValue)
                .font(.headline)
            Text(item.description)
            
            Spacer()
        }
        .padding()
    }
}

struct ContentDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetail(item: Item(name: "", imageUrl: URL(string: "")!, type: .food, description: ""))
    }
}
