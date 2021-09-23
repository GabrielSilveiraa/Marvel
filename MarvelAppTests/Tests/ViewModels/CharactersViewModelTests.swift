//
//  CharactersViewModelTests.swift
//  MarvelAppTests
//
//  Created by Gabriel Miranda Silveira on 20/09/21.
//

import XCTest
import Combine
@testable import MarvelApp

final class CharactersViewModelTests: XCTestCase {
    private var viewModel: CharactersViewModel!
    private var service: MockCharactersService!
    private var coordinator: MockCharactersCoordinatorNavigator!
    private var output: CharactersViewModelOutput!

    private var fakeViewDidLoadInput: CurrentValueSubject<Void, Never>!
    private var fakeDidSelectCellInput: PassthroughSubject<IndexPath, Never>!
    private var fakeWillDisplayCellInput: PassthroughSubject<IndexPath, Never>!
    private var fakeReloadButtonTappedInput: PassthroughSubject<Void, Never>!
    private var fakeSearchFilterTypedInput: PassthroughSubject<String, Never>!

    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        setup()
    }

    override func tearDown() {
        fakeViewDidLoadInput = nil
        fakeWillDisplayCellInput = nil
        fakeReloadButtonTappedInput = nil
        fakeDidSelectCellInput = nil
        fakeSearchFilterTypedInput = nil
        service = nil
        viewModel = nil
        subscriptions = []
        output = nil
        super.tearDown()
    }

    private func setup(serviceCharactersPublisher: AnyPublisher<[Character], Error>? = nil) {
        service = MockCharactersService()
        service.injectedCharactersPublisher = serviceCharactersPublisher
        coordinator = MockCharactersCoordinatorNavigator()
        viewModel = CharactersViewModel(service: service, coordinator: coordinator)
        setupInputAndOutput()
    }

    private func setupInputAndOutput() {
        fakeViewDidLoadInput = .init(())
        fakeWillDisplayCellInput = .init()
        fakeReloadButtonTappedInput = .init()
        fakeSearchFilterTypedInput = .init()
        fakeDidSelectCellInput = .init()
        
        let input = CharactersViewModelInput(viewDidLoad: fakeViewDidLoadInput.eraseToAnyPublisher(),
                                             didSelectCell: fakeDidSelectCellInput.eraseToAnyPublisher(),
                                             willDisplayCell: fakeWillDisplayCellInput.eraseToAnyPublisher(),
                                             searchFilterTyped: fakeSearchFilterTypedInput.eraseToAnyPublisher(),
                                             reloadButtonTapped: fakeReloadButtonTappedInput.eraseToAnyPublisher())
        output = viewModel.transform(input: input)
    }

    func testTransformReturnStaticOutputs() {
        XCTAssertEqual(output.title, "Marvel Characters")
        XCTAssertEqual(output.reloadButtonTitle, "There was an error. Tap to reload")
    }

    func testViewDidLoadFetchesItemsAndCellViewModelIsCorrectlyMapped() {
        let exp = expectation(description: "")
        self.service.injectedCharactersPublisher = Just(self.fakeCharacters(count: 2))
                                                    .setFailureType(to: Error.self)
                                                    .eraseToAnyPublisher()
        self.output.cellsViewModel
            .sink { items in
                XCTAssertEqual(items.count, 2)
                XCTAssertEqual(items[0].characterName, "fakeCharacter0")
                XCTAssertEqual(items[0].characterDescription, "fakeDescription0")
                XCTAssertEqual(items[0].imageUrl, URL(string: "http://fakePath0.fakeDescription0"))
                XCTAssertEqual(items[1].characterName, "fakeCharacter1")
                XCTAssertEqual(items[1].characterDescription, "fakeDescription1")
                XCTAssertEqual(items[1].imageUrl, URL(string: "http://fakePath1.fakeDescription1"))
                exp.fulfill()
            }
            .store(in: &self.subscriptions)

        wait(for: [exp], timeout: 5)
    }

    func testWillDisplayCellFetchesMoreItemsWhenMatchesCriteria() {
        let exp = expectation(description: "")
        var isFirstCall = true

        self.service.injectedCharactersPublisher = Just(self.fakeCharacters(count: 50))
                                                    .setFailureType(to: Error.self)
                                                    .eraseToAnyPublisher()

        output.cellsViewModel
            .sink { [weak self] items in
                guard !isFirstCall else {
                    isFirstCall = false
                    self?.fakeWillDisplayCellInput.send(IndexPath(row: 30, section: 0))
                    return
                }
                XCTAssertEqual(items.count, 100)
                exp.fulfill()
            }
            .store(in: &self.subscriptions)

        wait(for: [exp], timeout: 5)
    }

    func testWillDisplayCellDoesNotFetchMoreItemsWhenCriteriaIsNotMatch() {
        let notExpectation = expectation(description: "")
        notExpectation.isInverted = true
        var isFirstCall = true

        self.service.injectedCharactersPublisher = Just(self.fakeCharacters(count: 50))
                                                    .setFailureType(to: Error.self)
                                                    .eraseToAnyPublisher()

        output.cellsViewModel
            .sink { [weak self] items in
                guard !isFirstCall else {
                    isFirstCall = false
                    self?.fakeWillDisplayCellInput.send(IndexPath(row: 4, section: 0))
                    return
                }
                notExpectation.fulfill()
            }
            .store(in: &self.subscriptions)
        wait(for: [notExpectation], timeout: 5)
    }

    func testAnyCellIsReturnedAndErrorIsCalledWhenServiceReturnsError() {
        let notExpectation = expectation(description: "")
        notExpectation.isInverted = true

        let exp = expectation(description: "")

        self.service.injectedCharactersPublisher = Fail(error: TestError.fake).eraseToAnyPublisher()

        self.output.error
            .sink { error in
                XCTAssertEqual(error as? TestError, TestError.fake)
                exp.fulfill()
            }
            .store(in: &self.subscriptions)

        self.output.cellsViewModel
            .sink { _ in
                notExpectation.fulfill()
            }
            .store(in: &self.subscriptions)

        wait(for: [exp, notExpectation], timeout: 5)
    }

    func testReloadButtonTappedFetchesItems() {
        let exp = expectation(description: "")
        setup(serviceCharactersPublisher: Fail(error: TestError.fake).eraseToAnyPublisher())

        self.output.cellsViewModel
            .sink { items in
                XCTAssertEqual(items.count, 2)
                exp.fulfill()
            }
            .store(in: &self.subscriptions)

        self.service.injectedCharactersPublisher = Just(self.fakeCharacters(count: 2))
                                                    .setFailureType(to: Error.self)
                                                    .eraseToAnyPublisher()
        fakeReloadButtonTappedInput.send(())
        wait(for: [exp], timeout: 5)
    }

    func testSearchTypedFetchesItems() {
        let exp = expectation(description: "")

        self.service.injectedCharactersPublisher = Just(self.fakeCharacters(count: 2))
                                                    .setFailureType(to: Error.self)
                                                    .eraseToAnyPublisher()

        self.output.cellsViewModel
            .sink { items in
                XCTAssertEqual(items.count, 2)
                exp.fulfill()
            }
            .store(in: &self.subscriptions)

        fakeSearchFilterTypedInput.send("Fake Character")
        wait(for: [exp], timeout: 5)
    }

    func testCharacterSelectionSendsCharacterToCoordinator() {
        let exp = expectation(description: "")

        self.service.injectedCharactersPublisher = Just(self.fakeCharacters(count: 2))
                                                    .setFailureType(to: Error.self)
                                                    .eraseToAnyPublisher()

        self.output.cellsViewModel
            .sink { [weak self] _ in
                self?.fakeDidSelectCellInput.send(IndexPath(row: 0, section: 0))
                XCTAssertTrue(self?.coordinator.coordinatorCalled ?? false)
                XCTAssertEqual(self?.coordinator.characterCalled?.id, 0)
                XCTAssertEqual(self?.coordinator.characterCalled?.name, "fakeCharacter0")
                XCTAssertEqual(self?.coordinator.characterCalled?.description, "fakeDescription0")
                XCTAssertEqual(self?.coordinator.characterCalled?.thumbnail.url, URL(string: "http://fakePath0.fakeDescription0"))
                XCTAssertEqual(self?.coordinator.characterCalled?.comics.items.first?.name, "comic")
                XCTAssertEqual(self?.coordinator.characterCalled?.series.items.first?.name, "serie")
                XCTAssertEqual(self?.coordinator.characterCalled?.stories.items.first?.name, "story")
                exp.fulfill()
            }
            .store(in: &self.subscriptions)

        wait(for: [exp], timeout: 5)
    }

    func testCharacterSelectingInvalidIndexPathDoesNothing() {
        let exp = expectation(description: "")

        self.service.injectedCharactersPublisher = Just(self.fakeCharacters(count: 2))
                                                    .setFailureType(to: Error.self)
                                                    .eraseToAnyPublisher()

        self.output.cellsViewModel
            .sink { [weak self] _ in
                self?.fakeDidSelectCellInput.send(IndexPath(row: 2, section: 0))
                XCTAssertFalse(self?.coordinator.coordinatorCalled ?? true)
                XCTAssertNil(self?.coordinator.characterCalled)
                exp.fulfill()
            }
            .store(in: &self.subscriptions)

        wait(for: [exp], timeout: 5)
    }
}

 private extension CharactersViewModelTests {
     func fakeCharacters(count: Int) -> [Character] {
         (0..<count).indices.map { i in
             Character(id: i,
                       name: "fakeCharacter\(i)",
                        description: "fakeDescription\(i)",
                        thumbnail: .init(path: "http://fakePath\(i)",
                                         extension: "fakeDescription\(i)"),
                        resourceURI: "fakeResourceURI\(i)",
                        comics: .init(items: [.init(name: "comic")]),
                        series: .init(items: [.init(name: "serie")]),
                        stories: .init(items: [.init(name: "story")]))
         }
     }
 }
