//
//  ContentView.swift
//  LearnSwift
//
//  Created by James Layton on 1/4/23.
//

import SwiftUI

struct ContentView: View {
    
    var foodList: [String] = ["Tomato", "Bacon", "Apple1", "Banana", "Orange", "Shrimp", "Candy", "Water", "Apple2", "Apple3", "Notebook", "Pen", "Snacks", "iPhone", "iPad"]
    
    var body: some View {
        NavigationView {
            List(foodList, id: \.self) { food in
                Text(food)
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
