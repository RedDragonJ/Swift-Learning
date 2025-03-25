//
//  RickMortyRepresentable.swift
//  InfiniteScrollPage
//
//  Created by James Layton on 3/25/25.
//

import SwiftUI

struct RickMortyRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RickAndMortyViewController

    func makeUIViewController(context: Context) -> RickAndMortyViewController {
        .init()
    }
    
    func updateUIViewController(_ uiViewController: RickAndMortyViewController, context: Context) {
        // Update the tableviewcontroller if need
    }
}
