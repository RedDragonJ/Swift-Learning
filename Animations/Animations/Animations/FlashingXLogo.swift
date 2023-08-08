//
//  FlashingXLogo.swift
//  Animations
//
//  Created by James Layton on 7/31/23.
//

import SwiftUI

struct FlashingXLogo: View {
    
    @State private var isFlashing = false
    @State private var isScaling = false
    @State private var isSwitchView = false
    
    @State private var flashCount = 0
    
    @State private var showHomeX = false
    
    var body: some View {
        ZStack {
            if showHomeX {
                HomeX()
            } else {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .opacity(isSwitchView ? 1 : 0)
                
                Image("x")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .opacity(isFlashing ? 1.0 : 0.0)
                    .scaleEffect(isScaling ? 7 : 1)
                    .onAppear {
                        animateFlashingX()
                    }
            }
        }
    }
    
    private func animateFlashingX() {
        if flashCount < 5 {
            withAnimation(.easeInOut(duration: 0.3)) {
                isFlashing.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                flashCount += 1
                animateFlashingX()
            }
        } else if flashCount >= 5 {
            withAnimation(.easeInOut(duration: 0.4)) {
                isScaling.toggle()
                isFlashing.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut) {
                    isSwitchView.toggle()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showHomeX = true
            }
        }
    }
}

struct HomeX: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                List {
                    Text("I love Xeeting")
                        .foregroundColor(.white)
                        .listRowBackground(Color.secondary)
                    Text("I love Xeeting")
                        .foregroundColor(.white)
                        .listRowBackground(Color.secondary)
                    Text("I love Xeeting")
                        .foregroundColor(.white)
                        .listRowBackground(Color.secondary)
                }
                .background(.black)
                .scrollContentBackground(.hidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("x")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct FlashingXLogo_Previews: PreviewProvider {
    static var previews: some View {
        FlashingXLogo()
    }
}
