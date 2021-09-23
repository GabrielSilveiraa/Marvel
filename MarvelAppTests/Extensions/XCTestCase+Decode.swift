//
//  XCTestCase+Decode.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import XCTest

extension XCTestCase {
    func loadJson<T: Decodable>(filename fileName: String) -> T? {
        let bundle = Bundle.init(for: type(of: self))
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("error " + error.localizedDescription)
            }
        }
        return nil
    }
}


