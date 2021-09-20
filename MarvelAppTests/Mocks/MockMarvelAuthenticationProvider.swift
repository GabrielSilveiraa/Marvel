//
//  MockMarvelAuthenticationProvider.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 20/09/21.
//

@testable import MarvelApp

final class MockMarvelAuthenticationProvider: MarvelAuthenticationProviderProtocol {
    func getAuthentication() -> MarvelAuthenticationObject? {
        .init(apiKey: "fakeApiKey", hash: "fakeHash", timestamp: "fakeTimestamp")
    }
}
