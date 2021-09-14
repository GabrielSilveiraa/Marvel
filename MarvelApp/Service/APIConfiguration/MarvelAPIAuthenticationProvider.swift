//
//  MarvelAuthenticationProvider.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import Arcane

final class MarvelAuthenticationProvider {
    static func getAuthentication(publicKey: String = Constants.publicApiKey,
                                  privateKey: String = Constants.privateApiKey,
                                  timestamp: Int = Int(Date().timeIntervalSince1970)) -> [String: Any]? {

        guard let hash = Hash.MD5("\(timestamp)\(privateKey)\(publicKey)") else {
            return nil
        }

        let authenticationObject = MarvelAuthenticationObject(apiKey: publicKey,
                                                              hash: hash,
                                                              timestamp: timestamp.description)
        do {
            return try authenticationObject.asDictionary()
        } catch {
            print("MarvelAuthenticationObject not encoded: " + error.localizedDescription)
            return nil
        }
    }
}

private extension MarvelAuthenticationProvider {
    enum Constants {
        static let publicApiKey = "68364626efcdab8ed9a4fb21e4bb2872"
        static let privateApiKey = "183421a27ce97377f87d336a2e7cbc04b526ba62"
    }
}
