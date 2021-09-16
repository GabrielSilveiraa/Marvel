//
//  MarvelAuthenticationObject.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import Foundation

/// The authentication object model. It describes the needed parameters for authenticating the app with the server.
struct MarvelAuthenticationObject: Encodable {
    let apiKey: String
    let hash: String
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case hash
        case apiKey = "apikey"
        case timestamp = "ts"
    }
}


