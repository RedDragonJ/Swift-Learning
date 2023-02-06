//
//  ContentDetail.swift
//  LearnSwift
//
//  Created by James Layton on 1/22/23.
//

import SwiftUI

struct ContentDetail: View {
    
    var itemImageName: String
    var itemName: String
    var itemType: String = "Vegatable"
    var itemDecription: String = "This is a vegatable that is good for you. It is healthier option to eat vegatable everyday. To learn more about this particular vegatable, please go on Google and search it."
    
    var body: some View {
        VStack(spacing: 16) {
            Image(itemImageName.lowercased())
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
            Text(itemName)
                .font(.title)
            Text(itemType)
                .font(.headline)
            Text(itemDecription)
            
            Spacer()
        }
        .padding()
    }
}

struct ContentDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetail(itemImageName: "Tomato", itemName: "Tomato")
    }
}
