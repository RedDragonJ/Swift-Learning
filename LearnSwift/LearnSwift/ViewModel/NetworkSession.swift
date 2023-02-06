//
//  NetworkSession.swift
//  LearnSwift
//
//  Created by James Layton on 2/5/23.
//

import Foundation

protocol NetworkInterface {
    func fetchData(url: URL) async throws -> Data
}

class NetworkSession: NetworkInterface {
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession(configuration: .ephemeral)) {
        self.urlSession = urlSession
    }
    
    func fetchData(url: URL) async throws -> Data {
        let (data, response) = try await urlSession.data(from: url)
        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
