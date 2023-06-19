//
//  FirebaseManager.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 5/29/23.
//

import SwiftUI
import FirebaseAuth

class FirebaseManager: ObservableObject {
    
    private let firebaseFirestore = FirebaseDBManager.shared
    
    @Published var user: User?
    @Published var items: [Item] = []
    
    func createUser(email: String, password: String) {
        
        guard !email.isEmpty else {
            return
        }
        
        guard !password.isEmpty else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            
            if let error {
                print(error)
            } else if let authResult {
                print("Sign up successfully, here is your ID:", authResult.user.uid)
                self?.user = User(userId: authResult.user.uid)
            } else {
                // Unknown error
            }
        }
    }
    
    @MainActor
    func signinUser(email: String, password: String) async throws -> Bool {
        
        guard !email.isEmpty else {
            throw NSError(domain: "ErrorDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "No email"])
        }
        
        guard !password.isEmpty else {
            throw NSError(domain: "ErrorDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "No password"])
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            user = User(userId: result.user.uid)
            return true
        } catch {
            throw error
        }
    }
    
    func signInUserWithCredential(credential: AuthCredential, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            guard self != nil else { return }
            
            if let error {
                print(error)
                completion(false)
            } else if let result {
                print("Sign in successfully through Google login, here is your ID:", result.user.uid)
                self?.user = User(userId: result.user.uid)
                completion(true)
            } else {
                // Unknown error
                completion(false)
            }
        }
    }
    
    @MainActor
    func getShoppingList() async throws {
        guard let user else {
            return
        }
        
        items = try await firebaseFirestore.fetchShoppingList(userId: user.userId)
    }
    
    @MainActor
    func addNewItem(name: String, description: String, type: String) async throws {
        guard let user else {
            return
        }

        let newItem = Item(name: name, description: description, dateCreated: Date().toString(), type: ItemType(rawValue: type)!)
        
        try await firebaseFirestore.uploadShoppingItem(userId: user.userId, item: newItem)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short // 12/12/2000
        return dateFormatter.string(from: self)
    }
}
