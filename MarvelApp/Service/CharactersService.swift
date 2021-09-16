//
//  CharactersService.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import GMSNetworkLayer
import Combine

protocol CharactersServiceProtocol {
    func getCharacters(offset: Int) -> AnyPublisher<[Character], Error>
}

final class CharactersService {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager(session: .shared, loggingEnabled: true)) {
        self.networkManager = networkManager
    }
}

extension CharactersService: CharactersServiceProtocol {
    func getCharacters(offset: Int) -> AnyPublisher<[Character], Error> {
        Future<[Character], Error>() { [weak self] promise in
            let route = MarvelAPI(routeType: .getCharacters(offset: offset))
            self?.networkManager.request(route) { (result: Result<MarvelApiResponse<Character>, Error>) in
                switch result {
                case .success(let response):
                    promise(.success(response.data.results))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
