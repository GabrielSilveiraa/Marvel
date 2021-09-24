//
//  MarvelAuthenticationProvider.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import Arcane

/// Responsible for retrieving the authentication configs, as we need to send some authentication parameters in every service request
protocol MarvelAuthenticationProviderProtocol {
    func getAuthentication() -> MarvelAuthenticationObject?
}

final class MarvelAuthenticationProvider {
    private let hashProvider: HashProviderProtocol.Type
    private let publicKey: String
    private let privateKey: String
    private let timestamp: Int

    init(hashProvider: HashProviderProtocol.Type = Hash.self,
         publicKey: String = Constants.publicApiKey,
         privateKey: String = Constants.privateApiKey,
         timestamp: Int = Int(Date().timeIntervalSince1970)) {

        self.hashProvider = hashProvider
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.timestamp = timestamp
    }
}

extension MarvelAuthenticationProvider: MarvelAuthenticationProviderProtocol {
    /// It does a MD5 hash with some saved properties.
    /// - Returns:The object to be encoded into the request parameters
    func getAuthentication() -> MarvelAuthenticationObject? {
        guard let hash = hashProvider.MD5("\(timestamp)\(privateKey)\(publicKey)") else {
            return nil
        }

        return MarvelAuthenticationObject(apiKey: publicKey,
                                          hash: hash,
                                          timestamp: timestamp.description)
    }
}

private extension MarvelAuthenticationProvider {
    enum Constants {
        static let publicApiKey = "68364626efcdab8ed9a4fb21e4bb2872"
        static let privateApiKey = "183421a27ce97377f87d336a2e7cbc04b526ba62"
    }
}

protocol HashProviderProtocol {
    static func MD5(_ string: String) -> String?
}

extension Hash: HashProviderProtocol {}
