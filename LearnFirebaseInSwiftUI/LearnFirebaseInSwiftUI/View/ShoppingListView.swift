//
//  ShoppingListView.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 6/5/23.
//

import SwiftUI

struct ShoppingListView: View {
    
    @ObservedObject var firebaseManager: FirebaseManager
    
    var body: some View {
        VStack {
            if let item = firebaseManager.item {
                Text(item.id)
                Text(item.name)
                Text(item.description)
            } else {
                Text("No data or error")
            }
        }
        .task {
            do {
                try await firebaseManager.getShoppingList()
            } catch {
                print(error)
            }
        }
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView(firebaseManager: FirebaseManager())
    }
}
