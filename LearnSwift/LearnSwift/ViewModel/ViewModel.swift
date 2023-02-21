//
//  ViewModel.swift
//  LearnSwift
//
//  Created by James Layton on 2/5/23.
//

import UIKit

class ViewModel: ObservableObject {
    
    private var networkSession: NetworkInterface
    private var imageRepo: ImageRepoInterface
    
    @Published var items: [Item] = []
    
    init(networkSession: NetworkInterface = NetworkSession(),
         imageRepo: ImageRepoInterface = ImageRepo()) {
        self.networkSession = networkSession
        self.imageRepo = imageRepo
    }
    
    @MainActor
    func getImage(_ url: URL) async throws -> UIImage {
        if let image = try await imageRepo.getImage(url: url) {
            return image
        } else {
            return UIImage(systemName: "questionmark.circle.fill")!
        }
    }
    
    @MainActor
    func getAPIData(urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let responseData = try await networkSession.fetchData(url: url)
        
        do {
            items = try JSONDecoder().decode([Item].self, from: responseData)
        } catch let error {
            throw error
        }
    }
}
