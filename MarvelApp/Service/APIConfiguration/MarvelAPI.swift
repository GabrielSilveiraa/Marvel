//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import GMSNetworkLayer

enum MarvelAPI {
    case getCharacters(offset: Int)
}

extension MarvelAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: Constants.baseURL) else {
            fatalError("baseURL not set properly")
        }
        return url
    }

    var path: String {
        "/characters"
    }

    var httpMethod: HTTPMethod {
        .get
    }

    var encoding: ParameterEncoding? {
        .urlEncoding
    }

    var parameters: [String : Any] {
        var parameters: [String : Any] = [:]

        switch self {
        case .getCharacters(let offset):
            parameters["offset"] = offset
        }


        guard let authenticationParameters = MarvelAuthenticationProvider.getAuthentication() else { return parameters }
        return parameters.merging(authenticationParameters) { (_, new) in new }
    }
}

fileprivate extension MarvelAPI {
    enum Constants {
        static let baseURL = "https://gateway.marvel.com/v1/public"
    }
}
