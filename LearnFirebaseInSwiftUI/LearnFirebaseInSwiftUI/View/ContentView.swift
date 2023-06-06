//
//  ContentView.swift
//  LearnFirebaseInSwiftUI
//
//  Created by James Layton on 5/20/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var showSocialLogin: Bool = false
    @State private var showShoppingListView: Bool = false
    
    @StateObject private var firebaseManager = FirebaseManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .font(.headline)
            TextField("Ex: Sample@Sample.com", text: $email)
                .frame(height: 50)
                .border(.black)
            
            Text("Password")
                .font(.headline)
            TextField("Ex: 12345", text: $password)
                .frame(height: 50)
                .border(.black)
            
            VStack {
                Button {
                    signUpUser()
                } label: {
                    Text("Sign up")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    signInUser()
                } label: {
                    Text("Sign in")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    showSocialLogin.toggle()
                } label: {
                    Text("Google login")
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showSocialLogin) {
                    GoogleSignInView(firebaseManager: firebaseManager)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(32)
        .fullScreenCover(isPresented: $showShoppingListView) {
            ShoppingListView(firebaseManager: firebaseManager)
        }
    }
    
    func signUpUser() {
        Task {
            firebaseManager.createUser(email: email, password: password)
        }
    }
    
    func signInUser() {
        Task {
            if try await firebaseManager.signinUser(email: email, password: password) {
                showShoppingListView = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
