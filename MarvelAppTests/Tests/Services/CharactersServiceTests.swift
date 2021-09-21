//
//  CharactersServiceTests.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import XCTest
import Combine
@testable import MarvelApp

final class CharactersServiceTests: XCTestCase {
    private var service: CharactersService!
    private var mockNetworkManager: MockNetworkManager!
    private var subscriptions: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        service = CharactersService(networkManager: mockNetworkManager)
        subscriptions = Set<AnyCancellable>()
    }

    func testGetCharactersMapsResponseCorrectly() {
        let charactersJson: MarvelApiResponse<Character>? = loadJson(filename: "Characters")
        mockNetworkManager.forcedResponse = charactersJson
        service.getCharacters(filter: "", offset: 0, limit: 20)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { characters in
                    XCTAssertEqual(characters.count, 20)
                    XCTAssertEqual(characters.first?.name, "3-D Man")
                    XCTAssertEqual(characters.first?.description, "")
                    XCTAssertEqual(characters.first?.thumbnail.path, "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784")
                    XCTAssertEqual(characters.first?.thumbnail.extension, "jpg")
                    XCTAssertEqual(characters.first?.resourceURI, "http://gateway.marvel.com/v1/public/characters/1011334")
                    XCTAssertEqual(characters.first?.thumbnail.url, URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
                    XCTAssertEqual(characters.first?.id, 1011334)
                  })
            .store(in: &subscriptions)
    }

    func testGetCharactersMapsErrorOnServiceError() {
        mockNetworkManager.forcedError = TestError.fake
        service.getCharacters(filter: "", offset: 0, limit: 20)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? TestError, TestError.fake)
                }
            }, receiveValue: { _ in XCTFail() })
            .store(in: &subscriptions)
    }
}
