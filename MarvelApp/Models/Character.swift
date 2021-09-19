//
//  Character.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import Foundation

struct MarvelApiResponse<T: Decodable>: Decodable {
    let data: MarvelApiData<T>
}

struct MarvelApiData<T: Decodable>: Decodable {
    let results: [T]
}

struct Character: Decodable {
    let id: Int
    let name, description: String
    let thumbnail: Thumbnail
    let resourceURI: String
}

struct Thumbnail: Codable {
    let path: String
    let `extension`: String
}

extension Thumbnail {
    var url: URL? {
        URL(string: path + "." + `extension`)
    }
}

extension Character: Hashable {}
extension Thumbnail: Hashable {}
