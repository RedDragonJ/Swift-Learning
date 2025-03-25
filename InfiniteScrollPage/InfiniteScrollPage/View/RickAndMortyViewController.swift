//
//  RickAndMortyViewController.swift
//  InfiniteScrollPage
//
//  Created by James Layton on 3/25/25.
//

import UIKit

class RickAndMortyViewController: UITableViewController, UITableViewDataSourcePrefetching {

    private var currentPage: Int = 1
    private var rickMortyVM = RickMortyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(CharacterTableCell.self, forCellReuseIdentifier: "CharacterTableCellID")
        tableView.prefetchDataSource = self

        fetchCharacters()
    }

    func fetchCharacters() {
        Task {
            do {
                try await rickMortyVM.fetchData(page: currentPage)
                currentPage += 1
                tableView.reloadData()
            } catch {
                print("Error: \(error)")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rickMortyVM.rmCharacters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableCellID", for: indexPath) as! CharacterTableCell
        cell.configure(rmCharacter: rickMortyVM.rmCharacters[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row == rickMortyVM.rmCharacters.count - 5 }) {
            print("Fetch next page data...")
            fetchCharacters()
        }
    }
}
