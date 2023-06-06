//
//  FirebaseDBManager.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 6/5/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseDBManager {
    
    static let shared = FirebaseDBManager()
    
    private var fireDB = Firestore.firestore()
    
    init() {
        // Do nothing
    }
    
    func fetchShoppingList(userId: String) async throws -> Item {
        let docRef = fireDB.collection(userId).document("shoppingList")

        do {
            let documentResult = try await docRef.getDocument()
            
            if let dict = documentResult.data() {
                let data = try JSONSerialization.data(withJSONObject: dict)
                return try JSONDecoder().decode(Item.self, from: data)
            } else {
                throw NSError(domain: "ErrorDomain", code: 999)
            }
            
        } catch {
            throw error
        }
    }
}
