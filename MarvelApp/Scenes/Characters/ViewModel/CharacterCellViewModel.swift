//
//  CharacterCellViewModel.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 17/09/21.
//

import Foundation


struct CharacterCellViewModel {
    private let character: Character
    var imageUrl: URL? {
        character.thumbnail.url
    }

    init(character: Character) {
        self.character = character
    }
}

extension CharacterCellViewModel: Hashable {}
