//
//  MockHashProvider.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 20/09/21.
//

@testable import MarvelApp

final class MockHashProvider: HashProviderProtocol {
    static func MD5(_ string: String) -> String? {
        string
    }
}
