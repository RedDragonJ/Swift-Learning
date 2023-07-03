//
//  ShoppingListView.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 6/5/23.
//

import SwiftUI

struct ShoppingListView: View {
    
    @ObservedObject var firebaseManager: FirebaseManager
    
    @State private var showAddItemView = false
    
    var body: some View {
        VStack {
            List {
                ForEach(firebaseManager.items, id: \.self) { item in
                    if FirebaseRCManager.shared.isItemView_2 {
                        ItemView_2(name: item.name, description: item.description)
                    } else {
                        ItemView_1(name: item.name)
                    }
                }
                .onDelete(perform: delete)
            }
            
            Button {
                showAddItemView = true
            } label: {
                Text("+")
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showAddItemView) {
                AddItemView(firebaseManager: firebaseManager)
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
    
    func delete(at offsets: IndexSet) {
        Task {
            do {
                try await firebaseManager.deleteItem(atOffsets: offsets)
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
