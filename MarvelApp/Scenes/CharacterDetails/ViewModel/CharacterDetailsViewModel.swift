//
//  CharacterDetailsViewModel.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 23/09/21.
//

import Foundation
import Combine

protocol CharacterDetailsViewModelProtocol {
    func transform(input: CharacterDetailsViewModelInput) -> CharacterDetailsViewModelOutput
}

//MARK: - ViewModel's Input -
struct CharacterDetailsViewModelInput {
    let viewDidLoad: AnyPublisher<Void, Never>
    let sectionTapped: AnyPublisher<CharacterCollectionItemSection, Never>
}

//MARK: - ViewModel's Output -
struct CharacterDetailsViewModelOutput {
    let title: String
    let imageUrl: URL?
    let cellsViewModel: AnyPublisher<[(CharacterCollectionItemSection, [CharacterCollectionItemCellViewModel])], Never>
}

//MARK: - ViewModel -

final class CharacterDetailsViewModel {
    let character: Character
    private lazy var collections = [CharacterCollectionItemSection.comics : character.comics.items,
                                    CharacterCollectionItemSection.series : character.series.items,
                                    CharacterCollectionItemSection.stories : character.stories.items]

    private lazy var cellsViewModel: [(CharacterCollectionItemSection, [CharacterCollectionItemCellViewModel])] = collections.compactMap { tuple(for: $0.key) }

    init(character: Character) {
        self.character = character
    }

    private func tuple(for section: CharacterCollectionItemSection) -> (CharacterCollectionItemSection, [CharacterCollectionItemCellViewModel])? {
        guard let collection = collections[section] else { return nil }
        return (section, collection.compactMap { CharacterCollectionItemCellViewModel(collectionItem: $0) })
    }

    private func retrieveSectionTappedEvent(input: CharacterDetailsViewModelInput) -> AnyPublisher<Void, Never> {
        input.sectionTapped
            .flatMap { [weak self] section -> AnyPublisher<Void, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                let sections = self.cellsViewModel.map { $0.0 }
                if sections.contains(section) {
                    self.cellsViewModel = self.cellsViewModel.filter { $0.0 != section }
                } else {
                    if let tuple = self.tuple(for: section) {
                        self.cellsViewModel.append(tuple)
                    }
                }
                return Just<Void>(()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension CharacterDetailsViewModel: CharacterDetailsViewModelProtocol {
    func transform(input: CharacterDetailsViewModelInput) -> CharacterDetailsViewModelOutput {
        let sectionTappedEvent = retrieveSectionTappedEvent(input: input)

        let collectionsPublisher = Publishers.Merge(input.viewDidLoad, sectionTappedEvent)
            .flatMap { [weak self] _ -> AnyPublisher<[(CharacterCollectionItemSection, [CharacterCollectionItemCellViewModel])], Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return Just(self.cellsViewModel).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return .init(title: character.name,
                     imageUrl: character.thumbnail.url,
                     cellsViewModel: collectionsPublisher)
    }
}

enum CharacterCollectionItemSection: String, Hashable {
    case comics = "Comics"
    case series = "Series"
    case stories = "Stories"
}
