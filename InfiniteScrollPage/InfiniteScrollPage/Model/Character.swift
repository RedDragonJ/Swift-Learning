//
//  Character.swift
//  InfiniteScrollPage
//
//  Created by James Layton on 3/25/25.
//

import Foundation

struct CharacterResponse: Codable {
    let info: CharacterInfo
    let results: [CartoonCharacter]
}

struct CharacterInfo: Codable {
    let next: URL?
}

struct CartoonCharacter: Codable {
    let id: Double
    let name: String
    let image: URL
}
