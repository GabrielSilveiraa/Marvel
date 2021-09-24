//
//  CharactersView.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import UIKit

final class CharactersView: BaseView {
    //MARK: - UI Variables
    lazy var searchTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = .white
        textField.placeholder = Constants.searchPlaceholder
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "Filter input text"
        return textField
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CharacterCollectionViewCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "Collection of Characters"
        return collectionView
    }()

    let activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        indicatorView.color = .white
        indicatorView.accessibilityIdentifier = "Activity Indicator"
        return indicatorView
    }()

    let reloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.accessibilityIdentifier = "Reload Button"
        return button
    }()

    private var collectionViewLayout: UICollectionViewLayout {
        UICollectionViewCompositionalLayout.init { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
    }

    //MARK: - BaseView Setup
    func initialize() {
        backgroundColor = .blurredRedMarvel
        addSubview(searchTextField)
        addSubview(activityIndicatorView)
        addSubview(collectionView)
        addSubview(reloadButton)
    }

    func setupConstraints() {
        setupSearchTextFieldConstraints()
        setupCollectionViewConstraints()
        setupReloadButtonConstraints()
        setupIndicatorView()
    }

    //MARK: - Private Functions
    private func setupSearchTextFieldConstraints() {
        addConstraints([searchTextField.heightAnchor.constraint(equalToConstant: 30),
                        searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                        searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                        searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)])
    }

    private func setupCollectionViewConstraints() {
        addConstraints([collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                        collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                        collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
                        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }

    private func setupReloadButtonConstraints() {
        addConstraints([reloadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                        reloadButton.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }

    private func setupIndicatorView() {
        addConstraints([activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
                        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
}

fileprivate enum Constants {
    static let searchPlaceholder = "characters.search.title".localized
}
