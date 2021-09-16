//
//  CharactersViewController.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import UIKit
import Combine

final class CharactersViewController: ViewCodedViewController<CharactersView> {
    let viewModel: CharactersViewModelProtocol

    private lazy var viewModelOutput: CharactersViewModelOutput = {
        let input = CharactersViewModelInput(viewDidLoadPublisher: viewDidLoadSubject.eraseToAnyPublisher())
        return viewModel.transform(input: input)
    }()

    private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()

    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupBindings()
        viewDidLoadSubject.send(())
    }

    private func setupTitle() {
        title = viewModelOutput.title
    }

    private func setupBindings() {
//        viewModelOutput
    }

}

