//
//  CharacterDetailsViewController.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 23/09/21.
//

import UIKit
import Combine

final class CharacterDetailsViewController: ViewCodedViewController<CharacterDetailsView> {
    let viewModel: CharacterDetailsViewModelProtocol

    private lazy var viewModelOutput: CharacterDetailsViewModelOutput = {
        let input = CharacterDetailsViewModelInput(viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
                                                   sectionTapped: sectionTappedSubject.eraseToAnyPublisher())
        return viewModel.transform(input: input)
    }()

    //MARK: TableView DataSource
    private lazy var tableViewDataSource: UITableViewDiffableDataSource<CharacterCollectionItemSection, CharacterCollectionItemCellViewModel> = {
        .init(tableView: customView.tableView) { [unowned self] tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
            cell?.textLabel?.text = item.title
            return cell
        }
    }()

    private let viewDidLoadSubject: PassthroughSubject<Void, Never> = .init()
    private let sectionTappedSubject: PassthroughSubject<CharacterCollectionItemSection, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = .init()

    init(viewModel: CharacterDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModelOutput.title
        customView.characterImageView.kf.setImage(with: viewModelOutput.imageUrl)
        customView.tableView.delegate = self
        setupBindings()
        viewDidLoadSubject.send(())
    }

    private func setupBindings() {
        viewModelOutput.cellsViewModel
            .first()
            .sink { [weak self] characterCellsViewModel in
                self?.setupSnapshot(items: characterCellsViewModel, shouldAnimate: false)
            }
            .store(in: &subscriptions)

        viewModelOutput.cellsViewModel
            .dropFirst()
            .sink { [weak self] characterCellsViewModel in
                self?.setupSnapshot(items: characterCellsViewModel, shouldAnimate: true)
            }
            .store(in: &subscriptions)
    }

    private func setupSnapshot(items: [(CharacterCollectionItemSection, [CharacterCollectionItemCellViewModel])], shouldAnimate: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<CharacterCollectionItemSection, CharacterCollectionItemCellViewModel>()
        snapshot.appendSections([.comics, .series, .stories])
        items.forEach { item in
            snapshot.appendItems(item.1, toSection: item.0)
        }
        tableViewDataSource.apply(snapshot, animatingDifferences: shouldAnimate)
    }

    @objc private func hideSection(_ sender: UIButton) {
        let section = sender.tag
        sectionTappedSubject.send(tableViewDataSource.snapshot().sectionIdentifiers[section])
    }
}

extension CharacterDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !tableViewDataSource.snapshot().sectionIdentifiers.isEmpty else { return nil }

        let sectionButton = UIButton()
        let characterCollectionItemSection = tableViewDataSource.snapshot().sectionIdentifiers[section]

        sectionButton.setTitle(characterCollectionItemSection.rawValue, for: .normal)
        sectionButton.backgroundColor = .black
        sectionButton.tintColor = .white
        sectionButton.accessibilityIdentifier = characterCollectionItemSection.rawValue
        sectionButton.tag = section

        sectionButton.addTarget(self, action: #selector(self.hideSection), for: .touchUpInside)

        return sectionButton
    }
}
