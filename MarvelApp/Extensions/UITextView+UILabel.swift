//
//  UITextView+UILabel.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 19/09/21.
//

import UIKit

extension UITextView {
    convenience init(text: String = "",
                     fontType: FontType,
                     size: CGFloat,
                     textColor: UIColor = .black) {
        self.init()
        self.textColor = textColor
        self.font = fontType.font(size: size)
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
