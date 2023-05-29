//
//  FirebaseManager.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 5/29/23.
//

import Foundation
import FirebaseAuth

class FirebaseManager: ObservableObject {
    
    func createUser(email: String, password: String) {
        
        guard !email.isEmpty else {
            return
        }

        guard !password.isEmpty else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print(error)
            } else if let authResult {
                print("Sign up successfully, here is your ID:", authResult.user.uid)
            } else {
                // Unknown error
            }
        }
    }
    
    func signinUser(email: String, password: String) {
        
        guard !email.isEmpty else {
            return
        }

        guard !password.isEmpty else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error {
                print(error)
            } else if let authResult {
                print("Sign in successfully, here is your ID:", authResult.user.uid)
            } else {
                // Unknown error
            }
        }
    }
    
    func signInUserWithCredential(credential: AuthCredential, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            guard let strongSelf = self else { return }
            
            if let error {
                print(error)
                completion(false)
            } else if let result {
                print("Sign in successfully through Google login, here is your ID:", result.user.uid)
                completion(true)
            } else {
                // Unknown error
                completion(false)
            }
        }
    }
}
