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
        let authenticationProvider = MarvelAuthenticationProvider(hashProvider: MockHashProvider.self,
                                                                  publicKey: "publicFakeKey",
                                                                  privateKey: "privateFakeKey",
                                                                  timestamp: 123456)

        let authentication = authenticationProvider.getAuthentication()

        XCTAssertEqual(authentication?.apiKey, "publicFakeKey")
        XCTAssertEqual(authentication?.hash, "123456privateFakeKeypublicFakeKey")
        XCTAssertEqual(authentication?.timestamp, "123456")
    }
}

final class MockHashProvider: HashProviderProtocol {
    static func MD5(_ string: String) -> String? {
        string
    }
}
