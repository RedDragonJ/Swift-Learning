//
//  AddItemView.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 6/11/23.
//

import SwiftUI

struct AddItemView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var firebaseManager: FirebaseManager
    
    @State private var itemName = ""
    @State private var itemDescription = ""
    @State private var itemType: String = ItemType.snacks.rawValue
    
    @State private var allItem: [String] = ItemType.allCases.map { $0.rawValue }
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading) {
                Text("Item name")
                TextField("", text: $itemName)
                    .border(.black)
            }
            
            VStack(alignment: .leading) {
                Text("Item description")
                TextField("", text: $itemDescription)
                    .border(.black)
            }

            VStack(alignment: .leading) {
                Picker("Item type", selection: $itemType) {
                    ForEach($allItem, id: \.self) { item in
                        Text(item.wrappedValue)
                    }
                }
            }
            
            Button {
                Task {
                    do {
                        try await firebaseManager.addNewItem(name: itemName, description: itemDescription, type: itemType)
                        dismiss.callAsFunction()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Add item")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(firebaseManager: FirebaseManager())
    }
}
