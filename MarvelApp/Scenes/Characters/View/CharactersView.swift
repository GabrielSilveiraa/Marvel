//
//  CharactersView.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import UIKit

final class CharactersView: BaseView {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
//        tableView.register(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: "")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    func initialize() {
        backgroundColor = .white
        addSubview(tableView)
    }

    func setupConstraints() {
        addConstraints([tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                        tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                        tableView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
