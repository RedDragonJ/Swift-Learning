//
//  ImageRepo.swift
//  LearnSwift
//
//  Created by James Layton on 2/20/23.
//

import UIKit

protocol ImageRepoInterface {
    func getImage(url: URL) async throws -> UIImage?
    func saveImageToCache(url: URL, data: Data, response: URLResponse)
    func fetchImage(url: URL) async throws -> UIImage?
}

class ImageRepo: ImageRepoInterface {
    
    private var urlSession: URLSession
    private var cache: URLCache
    
    init(urlSession: URLSession = URLSession(configuration: .ephemeral),
         cache: URLCache = URLCache.shared) {
        self.urlSession = urlSession
        self.cache = cache
    }
    
    func getImage(url: URL) async throws -> UIImage? {
        let request = URLRequest(url: url)
        
        if let cachedData = cache.cachedResponse(for: request)?.data {
            return UIImage(data: cachedData)
        } else {
            return try await fetchImage(url: url)
        }
    }
    
    func saveImageToCache(url: URL, data: Data, response: URLResponse) {
        let request = URLRequest(url: url)
        let cachedURLResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedURLResponse, for: request)
    }
    
    func fetchImage(url: URL) async throws -> UIImage? {
        let (data, response) = try await urlSession.data(from: url)
        guard let httpURLReponse = response as? HTTPURLResponse, httpURLReponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        saveImageToCache(url: url, data: data, response: response)
        return UIImage(data: data)
    }
}
