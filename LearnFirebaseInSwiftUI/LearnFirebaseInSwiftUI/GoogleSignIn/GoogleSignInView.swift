//
//  GoogleSignInView.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 5/29/23.
//

import SwiftUI

struct GoogleSignInView: UIViewControllerRepresentable {
    
    @ObservedObject var firebaseManager: FirebaseManager
    
    typealias UIViewControllerType = GoogleSignInViewController
    
    func makeUIViewController(context: Context) -> GoogleSignInViewController {
        let googleSignInVC = GoogleSignInViewController()
        return googleSignInVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Update viewcontroller
    }
}
