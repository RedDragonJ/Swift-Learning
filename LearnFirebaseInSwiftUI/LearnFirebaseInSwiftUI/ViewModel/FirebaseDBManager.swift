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
    
    func fetchShoppingList(userId: String) async throws -> [Item] {
        let docRef = fireDB.collection("Shopping").document(userId)

        do {
            let documentResult = try await docRef.getDocument()
            
            if let dict = documentResult.data(), let anyList = dict["shoppingList"] as? [Any] {
                let jsonData = try JSONSerialization.data(withJSONObject: anyList)
                return try JSONDecoder().decode([Item].self, from: jsonData)
            } else {
                throw NSError(domain: "ErrorDomain", code: 999)
            }
            
        } catch {
            throw error
        }
    }
    
    func uploadShoppingItem(userId: String, item: Item) async throws {
        let docRef = fireDB.collection("Shopping").document(userId)

        guard let itemData = try? JSONEncoder().encode(item) else {
            throw NSError(domain: "ErrorDomain", code: 999)
        }
        
        guard let itemJson = try? JSONSerialization.jsonObject(with: itemData) as? [String: Any] else {
            throw NSError(domain: "ErrorDomain", code: 999)
        }
        
        do {
            if try await docRef.getDocument().exists {
                try await docRef.updateData(["shoppingList": FieldValue.arrayUnion([itemJson])])
            } else {
                try await docRef.setData(["shoppingList": [itemJson]], merge: true)
            }
            
        } catch {
            throw error
        }
    }
    
    func removeShoppingItem(userId: String, item: Item) async throws {
        let docRef = fireDB.collection("Shopping").document(userId)

        guard let itemData = try? JSONEncoder().encode(item) else {
            throw NSError(domain: "ErrorDomain", code: 999)
        }
        
        guard let itemJson = try? JSONSerialization.jsonObject(with: itemData) as? [String: Any] else {
            throw NSError(domain: "ErrorDomain", code: 999)
        }
        
        do {
            if try await docRef.getDocument().exists {
                try await docRef.updateData(["shoppingList": FieldValue.arrayRemove([itemJson])])
            } else {
                throw NSError(domain: "ErrorDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "There is nothing to delete"])
            }
            
        } catch {
            throw error
        }
    }
}
