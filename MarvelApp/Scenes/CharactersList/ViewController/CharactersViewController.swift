//
//  CharactersViewController.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 14/09/21.
//

import UIKit
import Combine

final class CharactersViewController: ViewCodedViewController<CharactersView> {
    //MARK: - Private variables
    private let viewModel: CharactersViewModelProtocol

    private lazy var viewModelOutput: CharactersViewModelOutput = {
        let input = CharactersViewModelInput(viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
                                             didSelectCell: didSelectCellSubject.eraseToAnyPublisher(),
                                             willDisplayCell: willDisplayCellSubject.eraseToAnyPublisher(),
                                             searchFilterTyped: searchFilterTypeSubject.eraseToAnyPublisher(),
                                             reloadButtonTapped: reloadButtonTapSubject.eraseToAnyPublisher())
        return viewModel.transform(input: input)
    }()

    //MARK: TableView DataSource
    private lazy var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, CharacterCellViewModel> = {
        .init(collectionView: customView.collectionView) { [unowned self] (collectionView, indexPath, cellViewModel) -> UICollectionViewCell in
            let cell: CharacterCollectionViewCell = self.customView.collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(viewModel: cellViewModel)
            return cell
        }
    }()

    //MARK: Subject inputs
    private let viewDidLoadSubject: CurrentValueSubject<Void, Never> = .init(())
    private let didSelectCellSubject: PassthroughSubject<IndexPath, Never> = .init()
    private let willDisplayCellSubject: PassthroughSubject<IndexPath, Never> = .init()
    private let reloadButtonTapSubject: PassthroughSubject<Void, Never> = .init()
    private let searchFilterTypeSubject: PassthroughSubject<String, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = .init()

    //MARK: - Initialization
    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSubject.send(())
        setupTitle()
        setupReloadButtonTitle()
        setupTableViewDelegate()
        setupReloadButtonTarget()
        setupSearchTextFieldTarget()
        setupBindings()
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

    private func setupSearchTextFieldTarget() {
        customView.searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)
    }

    private func setupBindings() {
        viewModelOutput.cellsViewModel
            .handleEvents(receiveOutput: { [weak customView] _ in
                customView?.activityIndicatorView.stopAnimating()
                customView?.collectionView.isHidden = false
                customView?.reloadButton.isHidden = true
            })
            .sink { [weak self] characterCellsViewModel in
                self?.setupSnapshot(items: characterCellsViewModel)
            }
            .store(in: &subscriptions)

        let loaderInputs = Publishers.Merge(viewDidLoadSubject .eraseToAnyPublisher(),
                                            searchFilterTypeSubject.eraseToAnyPublisher()
                                                .flatMap { _ in Just(())})

        loaderInputs
            .sink { [weak customView]_ in
                customView?.activityIndicatorView.startAnimating()
            }
            .store(in: &subscriptions)

        viewModelOutput.error
            .sink { [weak self] _ in
                self?.customView.activityIndicatorView.stopAnimating()
                self?.customView.collectionView.isHidden = true
                self?.customView.reloadButton.isHidden = false
            }
            .store(in: &subscriptions)
    }

    @objc private func reloadButtonTapped() {
        reloadButtonTapSubject.send(())
    }

    @objc private func searchTextFieldDidChange(_ textField: UITextField) {
        searchFilterTypeSubject.send(textField.text ?? "")
    }

    private func setupSnapshot(items: [CharacterCellViewModel]) {
        let shouldAnimate = !collectionViewDataSource.snapshot().itemIdentifiers.isEmpty
        var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        collectionViewDataSource.apply(snapshot, animatingDifferences: shouldAnimate)
    }

}

//MARK: - UICollectionViewDelegate Functions -
extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCellSubject.send(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCellSubject.send(indexPath)
    }
}

//MARK: - UITextFieldDelegate Functions -
extension CharactersViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchFilterTypeSubject.send(textField.text ?? "")
    }
}

//MARK: - Section enum -
private enum Section {
    case main
}
