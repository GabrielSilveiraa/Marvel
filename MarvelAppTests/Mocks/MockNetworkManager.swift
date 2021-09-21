//
//  MockNetworkManager.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 20/09/21.
//

import GMSNetworkLayer

final class MockNetworkManager: NetworkManagerProtocol {
    var forcedResponse: Decodable?
    var forcedError: Error?

    func request<T>(_ route: EndPointType, completion: @escaping NetworkCompletion<T>) where T : Decodable {
        if let forcedResponse = forcedResponse as? T {
            completion(.success(forcedResponse))
        }

        if let forcedError = forcedError {
            completion(.failure(forcedError))
        }
    }
}

