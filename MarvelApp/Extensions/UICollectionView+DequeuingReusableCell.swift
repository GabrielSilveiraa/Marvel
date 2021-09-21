//
//  UICollectionView+DequeuingReusableCell.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 17/09/21.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            assertionFailure("Could not Dequeue reusable cell with identifier \(String(describing: T.self))")
            return T()
        }
        return cell
    }
}
