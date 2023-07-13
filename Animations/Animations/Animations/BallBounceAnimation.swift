//
//  BallBounceAnimation.swift
//  Animations
//
//  Created by James Layton on 7/12/23.
//

import SwiftUI

struct BallBounceAnimation: View {
    
    @State private var position = CGPoint(x: 100, y: 100)
    @State private var velocity = CGPoint(x: 5, y: 5)
    let circleSize: CGFloat = 50
    let screenBounds = UIScreen.main.bounds
    
    var body: some View {
        Circle()
            .frame(width: circleSize, height: circleSize)
            .foregroundColor(.blue)
            .position(position)
            .onAppear {
                startAnimation()
            }
            .onReceive(Timer.publish(every: 0.02, on: .main, in: RunLoop.Mode.common).autoconnect()) { _ in
                updatePosition()
            }
    }
    
    func startAnimation() {
        velocity = CGPoint(x: 5, y: 5)
    }
    
    func updatePosition() {
        let newPosition = CGPoint(x: position.x + velocity.x, y: position.y + velocity.y)
        
        if newPosition.x < circleSize / 2 || newPosition.x > screenBounds.width - circleSize / 2 {
            velocity.x *= -1
        }
        
        if newPosition.y < 0 - circleSize / 1.6 || newPosition.y > screenBounds.height - circleSize * 1.6 {
            velocity.y *= -1
        }
        
        position = newPosition
    }
}

struct BallBounceAnimation_Previews: PreviewProvider {
    static var previews: some View {
        BallBounceAnimation()
    }
}
