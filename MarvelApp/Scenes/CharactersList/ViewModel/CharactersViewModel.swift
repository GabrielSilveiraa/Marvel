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

//MARK: - ViewModel's Input -
struct CharactersViewModelInput {
    let viewDidLoad: AnyPublisher<Void, Never>
    let didSelectCell: AnyPublisher<IndexPath, Never>
    let willDisplayCell: AnyPublisher<IndexPath, Never>
    let searchFilterTyped: AnyPublisher<String, Never>
    let reloadButtonTapped: AnyPublisher<Void, Never>
}

//MARK: - ViewModel's Output -
struct CharactersViewModelOutput {
    let title: String
    let reloadButtonTitle: String
    let cellsViewModel: AnyPublisher<[CharacterCellViewModel], Never>

    //I could emit the error on cellsViewModel publisher, but I don't want to finish the publisher after throwing it
    //So that was a hack to avoid it
    let error: AnyPublisher<Error, Never>
}

//MARK: - ViewModel -
final class CharactersViewModel {

    //MARK: - Private variables
    private let errorSubject: PassthroughSubject<Error, Never> = .init()
    private let service: CharactersServiceProtocol
    private let serviceRequestCount = 50

    private weak var coordinator: CharactersCoordinatorNavigation?

    private var subscriptions: Set<AnyCancellable> = .init()
    private var characters: [Character] = []
    private var offset = 0
    private var filter = ""
    
    init(service: CharactersServiceProtocol, coordinator: CharactersCoordinatorNavigation?) {
        self.coordinator = coordinator
        self.service = service

    }

    //MARK: - Private functions
    private func retrieveScrollEvent(input: CharactersViewModelInput) -> AnyPublisher<Void, Never> {
        input.willDisplayCell
            .filter { [weak self] indexPath in
                guard let self = self else { return false }
                return indexPath.row >= self.characters.count - (self.serviceRequestCount / 2)
            }
            .throttle(for: .milliseconds(200), scheduler: RunLoop.main, latest: false)
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                self.offset += self.serviceRequestCount
                return Just<Void>(()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func retrieveReloadTapEvent(input: CharactersViewModelInput) -> AnyPublisher<Void, Never> {
        input.reloadButtonTapped
            .throttle(for: .seconds(3), scheduler: RunLoop.main, latest: false)
            .eraseToAnyPublisher()
    }

    private func retrieveFilterEvent(input: CharactersViewModelInput) -> AnyPublisher<Void, Never> {
        input.searchFilterTyped
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] filter in
                self?.offset = 0
                self?.filter = filter
            })
            .flatMap { _ in Just(()) }
            .eraseToAnyPublisher()
    }

    private func loadCharacters() -> AnyPublisher<[CharacterCellViewModel], Never> {
        service.getCharacters(filter: filter, offset: offset, limit: serviceRequestCount)
            .receive(on: RunLoop.main)
            .catch { [weak self] error -> AnyPublisher<[Character], Never> in
                self?.errorSubject.send(error)
                return Empty().eraseToAnyPublisher()
            }
            .handleEvents(receiveOutput: { [weak self] in
                guard let self = self else { return }
                self.offset == 0 ? self.characters = $0 : self.characters.append(contentsOf: $0)
            })
            .compactMap { [weak self] _ in self?.characters }
            .map { characters in
                characters.map { CharacterCellViewModel(character: $0) }
            }
            .eraseToAnyPublisher()
    }

    private func setupBinding(input: CharactersViewModelInput) {
        input.didSelectCell
            .sink { [weak self] indexPath in
                guard let self = self,
                      indexPath.row < self.characters.count
                else {
                    return
                }

                let character = self.characters[indexPath.row]
                self.coordinator?.navigateToCharacterDetails(character: character)
            }
            .store(in: &subscriptions)
    }
}

//MARK: - ViewModels's Protocol Conformance -
extension CharactersViewModel: CharactersViewModelProtocol {
    func transform(input: CharactersViewModelInput) -> CharactersViewModelOutput {
        setupBinding(input: input)

        let willDisplayCellEvent = retrieveScrollEvent(input: input)
        let searchFilterTypedEvent = retrieveFilterEvent(input: input)
        let reloadButtonEvent = retrieveReloadTapEvent(input: input)

        let charactersPublisher = Publishers.Merge4(input.viewDidLoad, willDisplayCellEvent, reloadButtonEvent, searchFilterTypedEvent)
            .flatMap { [weak self] _ in
                self?.loadCharacters() ?? Empty().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return .init(title: Constants.marvelCharactersTitle,
                     reloadButtonTitle: Constants.errorReloadButtonTitle,
                     cellsViewModel: charactersPublisher,
                     error: errorSubject.eraseToAnyPublisher())
    }
}

//MARK: - Constants -
fileprivate enum Constants {
    static let marvelCharactersTitle = "characters.title".localized
    static let errorReloadButtonTitle = "characters.reloadButton.title".localized
}
