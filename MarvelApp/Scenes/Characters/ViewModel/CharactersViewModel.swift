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
    let willDisplayCell: AnyPublisher<IndexPath, Never>
    let reloadButtonTapped: AnyPublisher<Void, Never>
}

struct CharactersViewModelOutput {
    let title: String
    let reloadButtonTitle: String
    let cellsViewModel: AnyPublisher<[CharacterCellViewModel], Never>

    //I could emit the error on cellsViewModel publisher, but I don't want to finish the publisher after throwing it
    //So that was a hack to avoid it
    let error: AnyPublisher<Error, Never>
}

final class CharactersViewModel {
    private let service: CharactersServiceProtocol
    private var characters: [CharacterCellViewModel] = []
    private var offset = 0
    private let errorSubject: PassthroughSubject<Error, Never> = .init()

    init(service: CharactersServiceProtocol = CharactersService()) {
        self.service = service
    }

    private func loadCharacters() -> AnyPublisher<[CharacterCellViewModel], Never> {
        service.getCharacters(offset: offset)
            .receive(on: RunLoop.main)
            .map { characters in
                characters.map { CharacterCellViewModel(character: $0) }
            }
            .catch { [weak self] error -> AnyPublisher<[CharacterCellViewModel], Never> in
                self?.errorSubject.send(error)
                return Just([]).eraseToAnyPublisher()
            }
            .filter { !$0.isEmpty }
            .handleEvents(receiveOutput: { [weak self] in self?.characters += $0 })
            .compactMap { [weak self] _ in self?.characters }
            .eraseToAnyPublisher()
    }

    private func retrieveScrollEvent(input: CharactersViewModelInput) -> AnyPublisher<Void, Never> {
        input.willDisplayCell
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .filter { [weak self] indexPath in
                guard let self = self else { return false }
                return indexPath.row >= self.characters.count - 15
            }
            .handleEvents(receiveOutput: { [weak self] _ in self?.offset += 20 })
            .flatMap { _ in Just(()) }
            .eraseToAnyPublisher()
    }

    private func retrieveReloadTapEvent(input: CharactersViewModelInput) -> AnyPublisher<Void, Never> {
        input.reloadButtonTapped
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

extension CharactersViewModel: CharactersViewModelProtocol {
    func transform(input: CharactersViewModelInput) -> CharactersViewModelOutput {
        let willDisplayCellEvent = retrieveScrollEvent(input: input)
        let reloadButtonEvent = retrieveReloadTapEvent(input: input)

        let charactersPublisher = Publishers.Merge3(input.viewDidLoad, willDisplayCellEvent, reloadButtonEvent)
            .flatMap { [weak self] _ in
                self?.loadCharacters() ?? Empty().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return .init(title: "Characters",
                     reloadButtonTitle: "There was an error. Tap to reload",
                     cellsViewModel: charactersPublisher,
                     error: errorSubject.eraseToAnyPublisher())
    }
}
