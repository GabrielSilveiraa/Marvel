//
//  CharactersView.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import UIKit

final class CharactersView: BaseView {
    //MARK: - UI Variables
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .redMarvel
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CharacterCollectionViewCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var collectionViewLayout: UICollectionViewLayout {
        UICollectionViewCompositionalLayout.init { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)

            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
    }

    var reloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    //MARK: - BaseView Setup
    func initialize() {
        backgroundColor = .redMarvel
        addSubview(collectionView)
        addSubview(reloadButton)
    }

    func setupConstraints() {
        setupCollectionViewConstraints()
        setupReloadButtonConstraints()
    }

    //MARK: - Private Functions
    private func setupCollectionViewConstraints() {
        addConstraints([collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                        collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }

    private func setupReloadButtonConstraints() {
        addConstraints([reloadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                        reloadButton.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
}
