//
//  MarvelAuthenticationObject.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import Foundation

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


