//
//  CharacterDetailsViewModelTests.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 23/09/21.
//

import XCTest
import Combine
@testable import MarvelApp

class CharacterDetailsViewModelTests: XCTestCase {
    var viewModel: CharacterDetailsViewModel!
    private var output: CharacterDetailsViewModelOutput!

    private var fakeViewDidLoadInput: PassthroughSubject<Void, Never>!
    private var fakeDidSelectSectionInput: PassthroughSubject<CharacterCollectionItemSection, Never>!

    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        fakeViewDidLoadInput = .init()
        fakeDidSelectSectionInput = .init()

        viewModel = CharacterDetailsViewModel(character: .init(id: 0,
                                                               name: "character",
                                                               description: "description",
                                                               thumbnail: .init(path: "", extension: ""),
                                                               resourceURI: "",
                                                               comics: .init(items: [.init(name: "comic")]),
                                                               series: .init(items: [.init(name: "serie")]),
                                                               stories: .init(items: [.init(name: "story")])))
        let input = CharacterDetailsViewModelInput(viewDidLoad: fakeViewDidLoadInput.eraseToAnyPublisher(),
                                                   sectionTapped: fakeDidSelectSectionInput.eraseToAnyPublisher())
        output = viewModel.transform(input: input)
    }

    override func tearDown() {
        fakeViewDidLoadInput = nil
        fakeDidSelectSectionInput = nil
        viewModel = nil
        output = nil
        super.tearDown()
    }

    func testViewDidLoadCallsCharacterCollections() {
        output.cellsViewModel
            .sink { collections in
                XCTAssertEqual(collections.count, 3)
                let series = collections.first(where: { $0.0 == .series })
                let comics = collections.first(where: { $0.0 == .comics })
                let stories = collections.first(where: { $0.0 == .stories })
                XCTAssertNotNil(series)
                XCTAssertNotNil(comics)
                XCTAssertNotNil(stories)
                XCTAssertEqual(stories?.1.count, 1)
                XCTAssertEqual(stories?.1.first?.title, "story")
                XCTAssertEqual(comics?.0, .comics)
                XCTAssertEqual(comics?.1.count, 1)
                XCTAssertEqual(comics?.1.first?.title, "comic")
                XCTAssertEqual(series?.1.count, 1)
                XCTAssertEqual(series?.1.first?.title, "serie")
            }
            .store(in: &subscriptions)

        fakeViewDidLoadInput.send(())
    }

    func testViewTapSectionRemoveCollection() {
        output.cellsViewModel
            .dropFirst()
            .sink { collections in
                let series = collections.first(where: { $0.0 == .series })
                let comics = collections.first(where: { $0.0 == .comics })
                let stories = collections.first(where: { $0.0 == .stories })
                XCTAssertNil(series)
                XCTAssertNotNil(comics)
                XCTAssertNotNil(stories)
            }
            .store(in: &subscriptions)

        fakeViewDidLoadInput.send(())
        fakeDidSelectSectionInput.send(.series)
    }
}
