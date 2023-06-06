//
//  Item.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 6/5/23.
//

import Foundation

enum ItemType: String, Codable {
    case drink = "Drink"
}

struct Item: Codable {
    var id: String
    var name: String
    var description: String
    var dateCreated: String
    var type: ItemType
}
