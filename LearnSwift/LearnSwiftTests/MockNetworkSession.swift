//
//  MockNetworkSession.swift
//  LearnSwiftTests
//
//  Created by James Layton on 3/6/23.
//

import Foundation

// Success data
//    [
//        {
//            "name": "Apple",
//            "imageUrl": "https://www.google.com",
//            "type": "fruit",
//            "description": "This is an apple"
//        }
//    ]

// Failed data
//    [
//        {
//            "name": "Apple",
//            "imageUrl": "https://www.google.com",
//            "type": "tree",
//            "description": "This is an apple"
//        }
//    ]

class MockNetworkSession: NetworkInterface {
    func fetchData(url: URL) async throws -> Data {
        let urlString = url.absoluteString
        
        var item = [String: String]()
        
        if urlString == "successUrl" {
            item = ["name": "Apple", "imageUrl": "https://www.google.com", "type": "fruit", "description": "This is an apple"]
            
        } else if urlString == "failedUrl" {
            item = ["name": "Apple", "imageUrl": "https://www.google.com", "type": "tree", "description": "This is an apple"]
        }
        
        let json = [item]
        return try JSONSerialization.data(withJSONObject: json)
    }
}
