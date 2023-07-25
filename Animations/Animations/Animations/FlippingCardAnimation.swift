//
//  FlippingCardAnimation.swift
//  Animations
//
//  Created by James Layton on 7/24/23.
//

import SwiftUI

struct FlippingCardAnimation: View {
    
    @State private var isFlipped = false
    @State private var isScaled = false
    
    var body: some View {
        VStack {
            ZStack {
                Group {
                    if isFlipped {
                        BackOfCardView()
                    } else {
                        FrontOfCardView()
                    }
                }
            }
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(isScaled ? 1.8 : 1.0)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.isFlipped.toggle()
                    self.isScaled.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            self.isScaled = false
                        }
                    }
                }
            }
        }
    }
}

struct FrontOfCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.blue)
                .frame(width: 250, height: 350)
            Text("Front of Card")
                .foregroundColor(.white)
                .font(.title)
        }
        .shadow(color: .black, radius: 5)
    }
}

struct BackOfCardView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.green)
                .frame(width: 250, height: 350)
            Text("Back of Card")
                .foregroundColor(.white)
                .font(.title)
        }
        .shadow(color: .black, radius: 5)
    }
}

struct FlippingCardAnimation_Previews: PreviewProvider {
    static var previews: some View {
        FlippingCardAnimation()
    }
}
