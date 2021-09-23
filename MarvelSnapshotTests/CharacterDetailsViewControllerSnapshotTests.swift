//
//  CharacterDetailsViewControllerSnapshotTests.swift
//  MarvelSnapshotTests
//
//  Created by Gabriel Miranda Silveira on 23/09/21.
//

import PixelTest
@testable import MarvelApp
import Combine

final class CharacterDetailsViewControllerSnapshotTests: PixelTestCase {
    private var viewController: CharacterDetailsViewController!
    private var viewModel: MockCharacterDetailsViewModel!
    private let layoutStyle: LayoutStyle = .fixed(width: 375, height: 667)

    override func setUp() {
        super.setUp()
        viewModel = MockCharacterDetailsViewModel()
        viewController = CharacterDetailsViewController(viewModel: viewModel)
        mode = .test
    }

    override func tearDown() {
        viewController = nil
        viewModel = nil
        super.tearDown()
    }


    func testCharacterDetailsViewControllerBuildsCorrectlyOnSuccess() {
        verify(viewController.view!, layoutStyle: layoutStyle)
    }
}

fileprivate class MockCharacterDetailsViewModel: CharacterDetailsViewModelProtocol {
    func transform(input: CharacterDetailsViewModelInput) -> CharacterDetailsViewModelOutput {
        .init(title: "Title",
              imageUrl: nil,
              cellsViewModel: Just([(.comics, [.init(collectionItem: .init(name: "Comic1")),
                                               .init(collectionItem: .init(name: "Comic2"))]),
                                    (.stories, [.init(collectionItem: .init(name: "Story"))])]).eraseToAnyPublisher())
    }
}
