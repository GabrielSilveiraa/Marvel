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
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        setupContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Private functions
    private func setupContraints() {
        addConstraints([imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }

    //MARK: - Internal functions
    func configure(viewModel: CharacterCellViewModel) {
        imageView.kf.setImage(with: viewModel.imageUrl)
    }
}

extension CharacterCollectionViewCell {
    static let reuseIdentifier = "CharacterCollectionViewCell"
}
