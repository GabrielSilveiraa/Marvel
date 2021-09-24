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
    let comics: CharacterCollection
    let series: CharacterCollection
    let stories: CharacterCollection
}

struct CharacterCollection: Decodable {
    var items: [Item]
}

extension Character {
    struct Thumbnail: Codable {
        let path: String
        let `extension`: String
    }
}



extension Character.Thumbnail {
    var url: URL? {
        URL(string: path + "." + `extension`)
    }
}

extension CharacterCollection {
    struct Item: Decodable {
        var name: String
    }
}

extension Character: Hashable {}
extension CharacterCollection: Hashable {}
extension CharacterCollection.Item: Hashable {}
extension Character.Thumbnail: Hashable {}
