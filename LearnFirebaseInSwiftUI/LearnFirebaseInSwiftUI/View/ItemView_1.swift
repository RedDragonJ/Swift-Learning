//
//  ItemView_1.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 7/3/23.
//

import SwiftUI

struct ItemView_1: View {
    
    let name: String
    
    var body: some View {
        VStack {
            Text(name)
                .font(.headline)
        }
    }
}

struct ItemView_1_Previews: PreviewProvider {
    static var previews: some View {
        ItemView_1(name: "Food")
    }
}
