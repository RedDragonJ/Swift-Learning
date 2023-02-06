//
//  ViewModel.swift
//  LearnSwift
//
//  Created by James Layton on 2/5/23.
//

import Foundation

class ViewModel: ObservableObject {
    
    private var networkSession: NetworkInterface
    
    @Published var items: [String] = []
    
    init(networkSession: NetworkInterface = NetworkSession()) {
        self.networkSession = networkSession
    }
    
    @MainActor
    func getAPIData(urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let responseData = try await networkSession.fetchData(url: url)
        let json = try JSONSerialization.jsonObject(with: responseData) as? [Any]
        print(json)
    }
}
