//
//  MarvelAPITests.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import XCTest
@testable import MarvelApp

class MarvelAPITests: XCTestCase {
    func testGetCharactersRouteBuildsCorrectly() {
        let getCharactersRoute = MarvelAPI.getCharacters(offset: 2)
        XCTAssertEqual(getCharactersRoute.baseURL, URL(string: "http://gateway.marvel.com/v1/public"))
        XCTAssertEqual(getCharactersRoute.path, "/characters")
        XCTAssertEqual(getCharactersRoute.httpMethod, .get)
        XCTAssertEqual(getCharactersRoute.parameters["offset"] as? Int, 2)
        testAuthenticationParametersArePresent(for: getCharactersRoute)
    }
}

extension MarvelAPITests {
    private func testAuthenticationParametersArePresent(for route: MarvelAPI) {
        XCTAssertNotNil(route.parameters["hash"])
        XCTAssertNotNil(route.parameters["ts"])
        XCTAssertNotNil(route.parameters["apiKey"])
    }
}
