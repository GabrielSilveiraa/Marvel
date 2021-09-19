//
//  CharacterCellViewModel.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 17/09/21.
//

import Foundation


struct CharacterCellViewModel {
    private let character: Character

    init(character: Character) {
        self.character = character
    }
}

//MARK: - Internal Variables
extension CharacterCellViewModel {
    var imageUrl: URL? {
        character.thumbnail.url
    }

    var characterName: String {
        character.name
    }

    var characterDescription: String {
        character.description
    }
}

extension CharacterCellViewModel: Hashable {}
