//
//  CellView.swift
//  LearnSwift
//
//  Created by James Layton on 1/16/23.
//

import SwiftUI

struct CellView: View {
    
    let objectTitle: String
    
    var body: some View {
        HStack {
            Image(objectTitle.lowercased())
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
            VStack(alignment: .leading) {
                Text(objectTitle)
                    .font(.headline)
                Text("This is \(objectTitle.lowercased()) that we use everyday")
                    .font(.caption)
            }
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(objectTitle: "Title")
    }
}
