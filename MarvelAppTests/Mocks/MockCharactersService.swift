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
    var filterCalled: String?
    var offsetCalled: Int?
    var limitCalled: Int?

    func getCharacters(filter: String, offset: Int, limit: Int) -> AnyPublisher<[Character], Error> {
        filterCalled = filter
        offsetCalled = offset
        limitCalled = limit
        return injectedCharactersPublisher
    }
}
