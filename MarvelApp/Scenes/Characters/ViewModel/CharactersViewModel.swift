//
//  CharactersViewModel.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import Foundation
import Combine

/*
 https://medium.com/blablacar-tech/rxswift-mvvm-66827b8b3f10
 */
protocol CharactersViewModelProtocol {
    func transform(input: CharactersViewModelInput) -> CharactersViewModelOutput
}

struct CharactersViewModelInput {
    let viewDidLoadPublisher: AnyPublisher<Void, Never>
}

struct CharactersViewModelOutput {
    let title: String
}

final class CharactersViewModel {
    private var subscriptions: Set<AnyCancellable> = .init()
    private let service: CharactersServiceProtocol

    init(service: CharactersServiceProtocol = CharactersService()) {
        self.service = service
    }

    private func loadCharacters() {
        service.getCharacters(offset: 0)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { characters in
            })
            .store(in: &subscriptions)
    }
}

extension CharactersViewModel: CharactersViewModelProtocol {
    func transform(input: CharactersViewModelInput) -> CharactersViewModelOutput {
        input.viewDidLoadPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.loadCharacters()
            })
            .store(in: &subscriptions)

        return .init(title: "Characters")
    }
}
