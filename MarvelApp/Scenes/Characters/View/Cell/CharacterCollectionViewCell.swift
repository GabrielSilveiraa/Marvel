//
//  CharacterCollectionViewCell.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 17/09/21.
//

import UIKit
import Kingfisher

final class CharacterCollectionViewCell: UICollectionViewCell {
    //MARK: - UI Variables
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()

    private var characterNameLabel: UILabel = {
        .init(fontType: .bold, size: 16, textColor: .blackMarvel, numberOfLines: 1)
    }()

    private let characterDescriptionTextView: UITextView = {
        .init(fontType: .regular, size: 14, textColor: .blackMarvel)
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setupContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Private functions
    private func initialize() {
        contentView.backgroundColor = .white
        contentView.addSubview(characterImageView)
        contentView.addSubview(characterNameLabel)
        contentView.addSubview(characterDescriptionTextView)
    }

    private func setupContraints() {
        setupCharacterImageViewConstraints()
        setupCharacterNameLabelConstraints()
        setupCharacterDescriptionLabelConstraints()
    }

    private func setupCharacterImageViewConstraints() {
        addConstraints([characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                        characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        characterImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor)])
    }

    private func setupCharacterNameLabelConstraints() {
        addConstraints([characterNameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
                        characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        characterNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)])
    }

    private func setupCharacterDescriptionLabelConstraints() {
        addConstraints([characterDescriptionTextView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
                        characterDescriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        characterDescriptionTextView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 8),
                        characterDescriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)])
    }

    //MARK: - Internal functions
    func configure(viewModel: CharacterCellViewModel) {
        characterImageView.kf.setImage(with: viewModel.imageUrl)
        characterNameLabel.text = viewModel.characterName
        characterDescriptionTextView.text = viewModel.characterDescription
    }
}

extension CharacterCollectionViewCell {
    static let reuseIdentifier = "CharacterCollectionViewCell"
}
