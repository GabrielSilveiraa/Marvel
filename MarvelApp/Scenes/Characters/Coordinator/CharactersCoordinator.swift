//
//  CharactersCoordinator.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import UIKit

final class CharactersCoordinator {
    var childCoordinators: [Coordinator] = []
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
}

extension CharactersCoordinator: Coordinator {
    func start() {
        let navigationController = UINavigationController()
        navigationController.setupAppearance()

        let service = CharactersService()
        let viewModel = CharactersViewModel(service: service)
        let viewController = CharactersViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
