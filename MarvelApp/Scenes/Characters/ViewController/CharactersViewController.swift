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
        let input = CharactersViewModelInput(viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
                                             willDisplayCell: willDisplayCellSubject.eraseToAnyPublisher(),
                                             reloadButtonTapped: reloadButtonTapSubject.eraseToAnyPublisher())
        return viewModel.transform(input: input)
    }()

    private lazy var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, CharacterCellViewModel> = {
        .init(collectionView: customView.collectionView) { [unowned self] (collectionView, indexPath, cellViewModel) -> UICollectionViewCell in
            let cell: CharacterCollectionViewCell = self.customView.collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(viewModel: cellViewModel)
            return cell
        }
    }()

    private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()
    private let willDisplayCellSubject: PassthroughSubject<IndexPath, Never> = .init()
    private let reloadButtonTapSubject: PassthroughSubject<Void, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = .init()

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
        setupReloadButtonTitle()
        setupTableViewDelegate()
        setupReloadButtonTarget()
        setupBindings()

        viewDidLoadSubject.send(())
    }

    //MARK: - Private Functions
    private func setupTitle() {
        title = viewModelOutput.title
    }

    private func setupReloadButtonTitle() {
        customView.reloadButton.setTitle(viewModelOutput.reloadButtonTitle, for: .normal)
    }

    private func setupTableViewDelegate() {
        customView.collectionView.delegate = self
    }

    private func setupReloadButtonTarget() {
        customView.reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModelOutput.cellsViewModel
            .sink { [weak self] characterCellsViewModel in
                self?.customView.collectionView.isHidden = false
                self?.customView.reloadButton.isHidden = true
                self?.setupSnapshot(items: characterCellsViewModel)
            }
            .store(in: &subscriptions)

        viewModelOutput.error
            .sink { [weak self] error in
                self?.customView.collectionView.isHidden = true
                self?.customView.reloadButton.isHidden = false
            }
            .store(in: &subscriptions)
    }

    @objc private func reloadButtonTapped() {
        reloadButtonTapSubject.send(())
    }

    private func setupSnapshot(items: [CharacterCellViewModel]) {
        let shouldAnimate = !collectionViewDataSource.snapshot().itemIdentifiers.isEmpty
        var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        collectionViewDataSource.apply(snapshot, animatingDifferences: shouldAnimate)
    }

}

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCellSubject.send(indexPath)
    }
}

private enum Section {
    case main
}
