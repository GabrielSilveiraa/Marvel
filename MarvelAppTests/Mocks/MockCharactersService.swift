//
//  MockCharactersService.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 20/09/21.
//

import Combine
@testable import MarvelApp

final class MockCharactersService: CharactersServiceProtocol {
    var injectedCharactersPublisher: AnyPublisher<[Character], Error>!

    func getCharacters(offset: Int) -> AnyPublisher<[Character], Error> {
        injectedCharactersPublisher
    }
}
