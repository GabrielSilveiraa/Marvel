//
//  MarvelAuthenticationProviderTests.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import XCTest
@testable import MarvelApp

class MarvelAuthenticationProviderTests: XCTestCase {
    func testGetAuthentication() {
        let expected = MarvelAuthenticationProvider.getAuthentication(publicKey: "publicFakeKey",
                                                                      privateKey: "privateFakeKey",
                                                                      timestamp: 123456) as? [String: String]

        XCTAssertEqual(expected, ["apikey": "publicFakeKey",
                                  "hash": "631878bdbb79b05ebbfeb07f1467c776",
                                  "ts": "123456"])
    }
}
