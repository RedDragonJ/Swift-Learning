//
//  CharacterTableCell.swift
//  InfiniteScrollPage
//
//  Created by James Layton on 3/25/25.
//

import UIKit

class CharacterTableCell: UITableViewCell {

    let nameLabel = UILabel()
    let characterImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Configure the label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0

        // Configure the image view
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.clipsToBounds = true
        characterImageView.layer.cornerRadius = 8

        // Create a horizontal stack view to contain the image and label
        let hStack = UIStackView(arrangedSubviews: [characterImageView, nameLabel])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(hStack)

        // Contrain the stack view to the content view with padding
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Fix the image view size
            characterImageView.widthAnchor.constraint(equalToConstant: 60),
            characterImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(rmCharacter: CartoonCharacter) {
        nameLabel.text = rmCharacter.name
        loadImage(url: rmCharacter.image)
    }

    @MainActor
    func loadImage(url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let image = UIImage(data: data)
                characterImageView.image = image
            } catch {
                print("Error downloading image: \(error)")
            }
        }
    }
}
