//
//  MockCharactersCoordinator.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 23/09/21.
//

import Foundation
@testable import MarvelApp

final class MockCharactersCoordinatorNavigator: CharactersCoordinatorNavigation {
    var coordinatorCalled = false
    var characterCalled: Character?

    func navigateToCharacterDetails(character: Character) {
        coordinatorCalled = true
        characterCalled = character
    }
}
