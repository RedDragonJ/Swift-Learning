//
//  ItemView_2.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 7/3/23.
//

import SwiftUI

struct ItemView_2: View {
    
    let name: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.headline)
            Text(description)
                .font(.caption)
                .multilineTextAlignment(.leading)
        }
    }
}

struct ItemView_2_Previews: PreviewProvider {
    static var previews: some View {
        ItemView_2(name: "Food", description: "This is food")
    }
}
