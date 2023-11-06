//
//  ContentView.swift
//  Animations
//
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIndex = 0

    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                Text("First View")
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("First")
                    }
                    .tag(0)

                Text("Second View")
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("Second")
                    }
                    .tag(1)

                Text("Third View")
                    .tabItem {
                        Image(systemName: "3.square.fill")
                        Text("Third")
                    }
                    .tag(2)
            }
            .animation(.default)

            CustomTabBar(selectedIndex: $selectedIndex)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedIndex: Int

    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                GeometryReader { geometry in
                    Button(action: {
                        withAnimation {
                            selectedIndex = index
                        }
                    }) {
                        VStack {
                            if selectedIndex == index {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 50, height: 50)
                                    .offset(y: -geometry.frame(in: .global).minY)
                                    .shadow(radius: 5)
                            } else {
                                Image(systemName: "\(index + 1).square.fill")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .background(Blur(style: .systemMaterialDark))
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
