//
//  GoogleSignInViewController.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 5/29/23.
//

import SwiftUI
import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class GoogleSignInViewController: UIViewController {
    
    @ObservedObject var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        signInWithGoogle()
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error {
                print(error)
            } else if let idToken = result?.user.idToken,
                        let accessToken = result?.user.accessToken {
                print("Sign in successfully with Google, here is your ID:", idToken.tokenString)
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                               accessToken: accessToken.tokenString)
                
                firebaseManager.signInUserWithCredential(credential: credential) { success in
                    DispatchQueue.main.async {
                        if success {
                            self.dismiss(animated: true)
                        }
                    }
                }
                
            } else {
                // Unknown error
            }
        }
    }
}
