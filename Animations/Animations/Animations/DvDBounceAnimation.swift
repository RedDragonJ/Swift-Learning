//
//  DvDBounceAnimation.swift
//  Animations
//
//  Created by James Layton on 7/17/23.
//

import SwiftUI

struct DvDView: View {
    
    var backgroundColor: Color
    let squareSize: CGFloat
    
    var body: some View {
        ZStack {
            backgroundColor
            
            Image("dvd")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: squareSize - 8, height: squareSize - 8)
                .foregroundColor(.white)
        }
        .frame(width: squareSize, height: squareSize)
    }
}

struct DvDBounceAnimation: View {
    @State private var position = CGPoint(x: 100, y: 100)
    @State private var velocity = CGPoint(x: 5, y: 5)
    @State private var backgroundColor = Color.blue
    let squareSize: CGFloat = 100
    let screenBounds = UIScreen.main.bounds
    
    var body: some View {
        DvDView(backgroundColor: backgroundColor, squareSize: squareSize)
            .foregroundColor(.blue)
            .position(position)
            .onAppear {
                startAnimation()
            }
            .onReceive(Timer.publish(every: 0.05, on: .main, in: RunLoop.Mode.common).autoconnect()) { _ in
                updatePosition()
            }
    }
    
    func startAnimation() {
        velocity = CGPoint(x: 5, y: 5)
    }
    
    func updatePosition() {
        let newPosition = CGPoint(x: position.x + velocity.x, y: position.y + velocity.y)
        
        if newPosition.x < squareSize / 2 || newPosition.x > screenBounds.width - squareSize / 2 {
            velocity.x *= -1
            randomBackgroundColor()
        }
        
        if newPosition.y < 0 - 8 || newPosition.y > screenBounds.height - squareSize {
            velocity.y *= -1
            randomBackgroundColor()
        }
        
        position = newPosition
    }
    
    func randomBackgroundColor() {
        var randomRed = Double.random(in: 0...1)
        var randomGreen = Double.random(in: 0...1)
        var randomBlue = Double.random(in: 0...1)
        
        // Avoid change background to white color
        while randomRed > 0.9 && randomGreen > 0.9 && randomBlue > 0.9 {
            randomRed = Double.random(in: 0...1)
            randomGreen = Double.random(in: 0...1)
            randomBlue = Double.random(in: 0...1)
        }
        
        backgroundColor = Color(red: randomRed, green: randomGreen, blue: randomBlue)
    }
}

struct DvDBounceAnimation_Previews: PreviewProvider {
    static var previews: some View {
        DvDBounceAnimation()
    }
}
