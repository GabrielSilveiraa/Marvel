//
//  UILabel+UIFont.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 19/09/21.
//

import UIKit

extension UILabel {
    convenience init(text: String = "",
                     fontType: FontType,
                     size: CGFloat,
                     textColor: UIColor = .black,
                     textAlignment: NSTextAlignment = .left,
                     numberOfLines: Int = 0) {
        self.init()
        self.textColor = textColor
        self.font = fontType.font(size: size)
        self.text = text
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

enum FontType {
    case regular, bold

    func font(size: CGFloat) -> UIFont {
        switch self {
        case .regular: return .systemFont(ofSize: size)
        case .bold: return .boldSystemFont(ofSize: size)
        }
    }
}
