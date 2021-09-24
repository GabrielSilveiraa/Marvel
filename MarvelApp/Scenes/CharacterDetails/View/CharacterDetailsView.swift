//
//  CharacterDetailsView.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 23/09/21.
//

import UIKit

final class CharacterDetailsView: BaseView {
    //MARK: - UI Variables
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        imageView.accessibilityIdentifier = "Character image"
        return imageView
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "Table of collections"
        return tableView
    }()

    //MARK: - BaseView Setup
    func initialize() {
        backgroundColor = .redMarvel
        addSubview(characterImageView)
        addSubview(tableView)
    }

    func setupConstraints() {
        setupCharacterImageViewConstraints()
        setupTableViewConstants()
    }

    //MARK: - Private Functions
    private func setupCharacterImageViewConstraints() {
        addConstraints([characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        characterImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                        characterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                        characterImageView.heightAnchor.constraint(equalToConstant: CGFloat(frame.height/5))])
    }

    private func setupTableViewConstants() {
        addConstraints([tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        tableView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 10),
                        tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                        tableView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
