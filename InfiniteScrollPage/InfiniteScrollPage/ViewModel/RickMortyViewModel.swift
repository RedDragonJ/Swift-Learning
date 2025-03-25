//
//  RickMortyViewModel.swift
//  InfiniteScrollPage
//
//  Created by James Layton on 3/25/25.
//

import Foundation

@Observable
class RickMortyViewModel {

    var rmCharacters: [CartoonCharacter] = []

    private let characterURLString = "https://rickandmortyapi.com/api/character/"

    func fetchData(page: Int) async throws {

        var finalURLString = characterURLString

        if page > 1 {
            finalURLString = characterURLString + "?page=\(page)"
        }

        guard let url = URL(string: finalURLString) else {
            throw URLError(.badURL)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let characterResult = try JSONDecoder().decode(CharacterResponse.self, from: data)
            rmCharacters.append(contentsOf: characterResult.results)

        } catch {
            throw error
        }
    }
}
