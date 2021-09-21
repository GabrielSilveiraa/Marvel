//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import Foundation

/// Protocol which describes the Coordinator pattern. Take a look at this example to learn more about it:
/// https://benoitpasquier.com/coordinator-pattern-swift/
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func add(childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    func remove(childCoordinator: Coordinator) {
        childCoordinators.removeAll { $0 === childCoordinator }
    }
}
