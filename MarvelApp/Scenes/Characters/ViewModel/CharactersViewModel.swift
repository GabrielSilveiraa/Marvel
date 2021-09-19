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
    let viewDidLoad: AnyPublisher<Void, Never>
    let willDisPlayCell: AnyPublisher<IndexPath, Never>
}

struct CharactersViewModelOutput {
    let title: String
    let cellsViewModel: AnyPublisher<[CharacterCellViewModel], Error>
}

final class CharactersViewModel {
    private let service: CharactersServiceProtocol
    private var characters: [CharacterCellViewModel] = []
    private var offset = 0

    init(service: CharactersServiceProtocol = CharactersService()) {
        self.service = service
    }

    private func loadCharacters() -> AnyPublisher<[CharacterCellViewModel], Error> {
        service.getCharacters(offset: offset)
            .receive(on: RunLoop.main)
            .map { characters in
                characters.map { CharacterCellViewModel(character: $0) }
            }
            .handleEvents(receiveOutput: { [weak self] in self?.characters += $0 })
            .compactMap { [weak self] _ in self?.characters }
            .eraseToAnyPublisher()
    }

    private func retrieveScrollEvent(input: CharactersViewModelInput) -> AnyPublisher<Void, Never> {
        input.willDisPlayCell
            .filter { [weak self] indexPath in
                guard let self = self else { return false }
                return indexPath.row >= self.characters.count - 10
            }
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] _ in self?.offset += 20 })
            .flatMap { _ in Just(()) }
            .eraseToAnyPublisher()
    }
}

extension CharactersViewModel: CharactersViewModelProtocol {
    func transform(input: CharactersViewModelInput) -> CharactersViewModelOutput {
        let willDisplayCellEvent = retrieveScrollEvent(input: input)

        let charactersPublisher = Publishers.Merge(input.viewDidLoad, willDisplayCellEvent)
            .flatMap { [weak self] _ in
                self?.loadCharacters() ?? Empty().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return .init(title: "Characters",
                     cellsViewModel: charactersPublisher)
    }
}
