//
//  ContentView.swift
//  LearnSwift
//
//  Created by James Layton on 1/4/23.
//

import SwiftUI

struct ContentView: View {
    
    var foodList: [String] = ["Tomato", "Meat", "Apple", "Banana", "Orange", "Shrimp", "Candy", "Phone", "Laptop"]
    
    var body: some View {
        NavigationView {
            List(foodList, id: \.self) { food in
                
                ZStack(alignment: .leading) {
                    NavigationLink {
                        ContentDetail(itemImageName: food, itemName: food)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    CellView(objectTitle: food)
                }
            }
            .navigationTitle("Food List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
