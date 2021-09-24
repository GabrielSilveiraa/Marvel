//
//  CharacterCollectionItemCellViewModel.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 23/09/21.
//

import Foundation

struct CharacterCollectionItemCellViewModel {
    let id = UUID()
    private let collectionItem: CharacterCollection.Item

    init(collectionItem: CharacterCollection.Item) {
        self.collectionItem = collectionItem
    }
}

//MARK: - Internal Variables
extension CharacterCollectionItemCellViewModel {
    var title: String {
        collectionItem.name
    }
}

extension CharacterCollectionItemCellViewModel: Hashable {}
