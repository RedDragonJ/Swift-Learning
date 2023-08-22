//
//  PepeAndParticleAnimation.swift
//  Animations
//
//  Created by James Layton on 8/14/23.
//

import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGSize
    var color: Color?
    var imageName: String?
}

struct PepeAndParticleAnimation: View {
    
    @StateObject private var particleEmitter = ParticleEmitter()
    private var emitTime = 0.05
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particleEmitter.particles) { particle in
                    if let imageName = particle.imageName {
                        withAnimation(.linear(duration: emitTime)) {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .position(particle.position)
                        }
                    } else {
                        withAnimation(.linear(duration: emitTime)) {
                            Circle()
                                .foregroundColor(particle.color)
                                .frame(width: 25, height: 25)
                                .position(particle.position)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: emitTime, repeats: true) { _ in
                    if Bool.random() {
                        particleEmitter.emitImageParticle(in: geometry.size)
                    } else {
                        particleEmitter.emitCircleParticle(in: geometry.size)
                    }
                    particleEmitter.updateParticles()
                }
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
}

class ParticleEmitter: ObservableObject {
    
    @Published var particles: [Particle] = []
    
    func emitCircleParticle(in bounds: CGSize) {
        let position = CGPoint(x: CGFloat.random(in: 0..<bounds.width), y: CGFloat.random(in: 0..<bounds.height))
        let velocity = CGSize(width: Double.random(in: -5...5), height: Double.random(in: -5...5))
        let color = Color.random
        particles.append(Particle(position: position, velocity: velocity, color: color))
    }
    
    func emitImageParticle(in bounds: CGSize) {
        let position = CGPoint(x: CGFloat.random(in: 0..<bounds.width), y: CGFloat.random(in: 0..<bounds.height))
        let velocity = CGSize(width: Double.random(in: -5...5), height: Double.random(in: -5...5))
        particles.append(Particle(position: position, velocity: velocity, imageName: "pepe"))
    }
    
    func updateParticles() {
        particles = particles.map { particle in
            var updatedParticle = particle
            updatedParticle.position.x += particle.velocity.width
            updatedParticle.position.y += particle.velocity.height
            return updatedParticle
        }
        
        particles.removeAll { particle in
            particle.position.x < 0 || particle.position.x > UIScreen.main.bounds.width || particle.position.y < 0 || particle.position.y > UIScreen.main.bounds.height
        }
    }
}

extension Color {
    static var random: Color {
        Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}

struct PepeAndParticleAnimation_Previews: PreviewProvider {
    static var previews: some View {
        PepeAndParticleAnimation()
    }
}
