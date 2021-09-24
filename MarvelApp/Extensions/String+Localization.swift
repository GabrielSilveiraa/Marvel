//
//  String+Localization.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 24/09/21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
