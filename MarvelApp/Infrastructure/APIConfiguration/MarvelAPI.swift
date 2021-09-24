//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import GMSNetworkLayer


/// Responsible for declaring every possible route for the MarvelAPI
enum MarvelAPIRoute {
    case getCharacters(name: String?, offset: Int, limit: Int)
}

/// Contains the needed logic for creating any route from `MarvelAPIRoute`
final class MarvelAPI {
    private let routeType: MarvelAPIRoute
    private let authenticationProvider: MarvelAuthenticationProviderProtocol

    init(routeType: MarvelAPIRoute,
         authenticationProvider: MarvelAuthenticationProviderProtocol = MarvelAuthenticationProvider()) {
        self.routeType = routeType
        self.authenticationProvider = authenticationProvider
    }
}

extension MarvelAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: Constants.baseURL) else {
            fatalError("baseURL not set properly")
        }
        return url
    }

    var path: String {
        switch routeType {
        case .getCharacters:
            return "/characters"
        }
    }

    var httpMethod: HTTPMethod {
        switch routeType {
        case .getCharacters:
            return .get
        }
    }

    var encoding: ParameterEncoding? {
        switch routeType {
        case .getCharacters:
            return .urlEncoding
        }
    }

    var parameters: [String : Any] {
        var parameters: [String : Any] = [:]

        switch routeType {
        case .getCharacters(let name, let offset, let limit):
            if let name = name, !name.isEmpty {
                parameters["nameStartsWith"] = name
            }
            parameters["limit"] = limit
            parameters["offset"] = offset
        }

        do {
            if let authenticationParameters = try authenticationProvider.getAuthentication()?.asDictionary() {
                return parameters.merging(authenticationParameters) { (_, new) in new }
            }
        } catch {
            print("MarvelAuthenticationObject not encoded: " + error.localizedDescription)
        }

        return parameters
    }
}

private extension MarvelAPI {
    enum Constants {
        static let baseURL = "https://gateway.marvel.com/v1/public"
    }
}
