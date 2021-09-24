//
//  CharactersViewControllerSnapshotTests.swift
//  MarvelSnapshotTests
//
//  Created by Gabriel Miranda Silveira on 20/09/21.
//

import PixelTest
@testable import MarvelApp
import Combine

final class CharactersViewControllerSnapshotTests: PixelTestCase {
    private var viewController: CharactersViewController!
    private var viewModel: MockCharactersViewModel!
    private let layoutStyle: LayoutStyle = .fixed(width: 375, height: 667)

    override func setUp() {
        super.setUp()
        mode = .test
    }

    override func tearDown() {
        viewController = nil
        viewModel = nil
        super.tearDown()
    }

    private func setup(shouldReturnError: Bool = false) {
        viewModel = MockCharactersViewModel(shouldReturnError: shouldReturnError)
        viewController = CharactersViewController(viewModel: viewModel)
    }

    func testCharactersViewControllerBuildsCorrectlyOnSuccess() {
        setup()
        verify(viewController.view!, layoutStyle: layoutStyle)
    }

    func testCharactersViewControllerBuildsCorrectlyOnError() {
        setup(shouldReturnError: true)
        verify(viewController.view!, layoutStyle: layoutStyle)
    }
}

fileprivate class MockCharactersViewModel: CharactersViewModelProtocol {
    let shouldReturnError: Bool

    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }

    func transform(input: CharactersViewModelInput) -> CharactersViewModelOutput {
        shouldReturnError
            ? .init(title: "Title",
                    reloadButtonTitle: "ReloadButton",
                    cellsViewModel: Empty().eraseToAnyPublisher(),
                    error: Just(TestError.fake).eraseToAnyPublisher())

            : .init(title: "Title",
                    reloadButtonTitle: "ReloadButton",
                    cellsViewModel: Just([CharacterCellViewModel(character: .init(id: 1,
                                                                                  name: "Character",
                                                                                  description: "Description",
                                                                                  thumbnail: .init(path: "", extension: ""),
                                                                                  resourceURI: "",
                                                                                  comics: .init(items: []),
                                                                                  series: .init(items: []),
                                                                                  stories: .init(items: []))),
                                          CharacterCellViewModel(character: .init(id: 1,
                                                                                  name: "Character 2",
                                                                                  description: "Description 2",
                                                                                  thumbnail: .init(path: "", extension: ""),
                                                                                  resourceURI: "",
                                                                                  comics: .init(items: []),
                                                                                  series: .init(items: []),
                                                                                  stories: .init(items: [])))]).eraseToAnyPublisher(),
                    error: Empty().eraseToAnyPublisher())
    }
}
