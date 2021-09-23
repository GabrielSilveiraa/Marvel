//
//  CharactersCoordinator.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import UIKit

protocol CharactersCoordinatorNavigation: AnyObject {
    func navigateToCharacterDetails(character: Character)
}

final class CharactersCoordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow

    private var rootViewController: UINavigationController? {
        window.rootViewController as? UINavigationController
    }


    init(window: UIWindow) {
        self.window = window
    }
}

extension CharactersCoordinator: Coordinator {
    func start() {
        let navigationController = UINavigationController()
        navigationController.setupAppearance()

        let service = CharactersService()
        let viewModel = CharactersViewModel(service: service, coordinator: self)
        let viewController = CharactersViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension CharactersCoordinator: CharactersCoordinatorNavigation {
    func navigateToCharacterDetails(character: Character) {
        let viewModel = CharacterDetailsViewModel(character: character)
        let viewController = CharacterDetailsViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .currentContext
        present(viewController: viewController)
    }
}

extension CharactersCoordinator {
    func present(viewController: UIViewController) {
        let navigationController = UINavigationController()
        navigationController.setupAppearance()
        navigationController.viewControllers = [viewController]

        rootViewController?.present(navigationController, animated: true)
    }
}
