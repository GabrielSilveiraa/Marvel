//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import UIKit

/// TypeAlias which makes a BaseView inherits from BaseViewClass and conforms to BaseViewProtocol
/// `Always use it for creating your view coded layouts. It will help you 😊`
typealias BaseView = BaseViewClass & BaseViewProtocol

/// The protocol which describes how a custom BaseView should be created
protocol BaseViewProtocol {
    func initialize()
    func setupConstraints()
}

/// A Custom UIView class designed to use with view coded layout**
/// **Lifecycle:**
/// 1. `init()`
/// 2. `initialize()` *Add subviews*
/// 3. `installConstraints()` *Setup constraints*
class BaseViewClass: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    private func setup() {
        guard let self = self as? BaseView else {
            fatalError("Use BaseView instead of BaseViewClass")
        }
        self.initialize()
        self.setupConstraints()
    }
}
