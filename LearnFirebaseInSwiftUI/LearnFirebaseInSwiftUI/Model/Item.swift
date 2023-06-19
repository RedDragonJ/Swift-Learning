//
//  Item.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 6/5/23.
//

import Foundation

enum ItemType: String, Codable, CaseIterable {
    case drink = "Drink"
    case fruit = "Fruit"
    case meat = "Meat"
    case snacks = "Snacks"
}

struct Item: Codable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var dateCreated: String
    var type: ItemType
}
