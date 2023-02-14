//
//  Items.swift
//  LearnSwift
//
//  Created by James Layton on 2/13/23.
//

import Foundation

struct Item: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var imageUrl: URL
    var type: ItemType
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl
        case type
        case description
    }
    
    enum ItemType: String, Codable {
        case fruit
        case sweets
        case meat
        case mobile
        case food
    }
}
