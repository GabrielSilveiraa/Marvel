//
//  MarvelAPITests.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import XCTest
@testable import MarvelApp

final class MarvelAPITests: XCTestCase {
    private var marvelAuthenticationProvider = MockMarvelAuthenticationProvider()

    func testGetCharactersRouteBuildsCorrectly() {
        let getCharactersRoute = MarvelAPI(routeType: .getCharacters(name: "Fake", offset: 2, limit: 20), authenticationProvider: marvelAuthenticationProvider)
        XCTAssertEqual(getCharactersRoute.baseURL, URL(string: "https://gateway.marvel.com/v1/public"))
        XCTAssertEqual(getCharactersRoute.path, "/characters")
        XCTAssertEqual(getCharactersRoute.httpMethod, .get)
        XCTAssertEqual(getCharactersRoute.parameters["offset"] as? Int, 2)
        XCTAssertEqual(getCharactersRoute.parameters["nameStartsWith"] as? String, "Fake")
        XCTAssertEqual(getCharactersRoute.parameters["limit"] as? Int, 20)
        testAuthenticationParametersArePresent(for: getCharactersRoute)
    }

    func testGetCharactersRouteWithNoFilterBuildsCorrectly() {
        let getCharactersRoute = MarvelAPI(routeType: .getCharacters(name: "", offset: 2, limit: 20), authenticationProvider: marvelAuthenticationProvider)
        XCTAssertEqual(getCharactersRoute.baseURL, URL(string: "https://gateway.marvel.com/v1/public"))
        XCTAssertEqual(getCharactersRoute.path, "/characters")
        XCTAssertEqual(getCharactersRoute.httpMethod, .get)
        XCTAssertEqual(getCharactersRoute.parameters["offset"] as? Int, 2)
        XCTAssertEqual(getCharactersRoute.parameters["limit"] as? Int, 20)
        XCTAssertNil(getCharactersRoute.parameters["nameStartsWith"])
        testAuthenticationParametersArePresent(for: getCharactersRoute)
    }
}

extension MarvelAPITests {
    private func testAuthenticationParametersArePresent(for route: MarvelAPI) {
        XCTAssertEqual(route.parameters["hash"] as? String, "fakeHash")
        XCTAssertEqual(route.parameters["ts"] as? String, "fakeTimestamp")
        XCTAssertEqual(route.parameters["apikey"] as? String, "fakeApiKey")
    }
}
