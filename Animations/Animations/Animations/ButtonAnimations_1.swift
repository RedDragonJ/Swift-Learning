//
//  ButtonAnimations_1.swift
//  Animations
//
//  Created by James Layton on 6/20/23.
//

import SwiftUI

struct ButtonAnimations_1: View {
    
    @State private var isScaleAnimating = false
    @State private var isFadeAnimating = false
    @State private var isColored = false
    
    var body: some View {
        VStack(spacing: 16) {
            buttonWithScaleAnimation
            buttonWithFadeAnimation
            buttonWithColoringAnimation
        }
    }
    
    private var buttonWithScaleAnimation: some View {
        Button {
            withAnimation(isScaleAnimating ? .easeInOut(duration: 1.0) : .easeInOut(duration: 1.0).repeatForever()) {
                isScaleAnimating.toggle()
            }
        } label: {
            Text("Scale Animation")
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
                .shadow(color: .black, radius: 3)
        }
        .scaleEffect(isScaleAnimating ? 1.5 : 1.0)
    }
    
    private var buttonWithFadeAnimation: some View {
        Button {
            withAnimation(.easeInOut(duration: 1.0)) {
                isFadeAnimating.toggle()
            }
        } label: {
            Text("Fade Animation")
                .padding()
                .background(.green)
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
                .shadow(color: .black, radius: 3)
        }
        .opacity(isFadeAnimating ? 0.0 : 1.0)
    }
    
    private var buttonWithColoringAnimation: some View {
        Button {
            withAnimation(.easeInOut(duration: 1.0)) {
                isColored.toggle()
            }
        } label: {
            Text("Color Animation")
                .padding()
                .background(
                    ZStack {
                        if isColored {
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing)
                        } else {
                            Color.gray
                        }
                    }
                )
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
                .shadow(color: .black, radius: 3)
        }
    }
}

struct ButtonAnimations_1_Previews: PreviewProvider {
    static var previews: some View {
        ButtonAnimations_1()
    }
}
