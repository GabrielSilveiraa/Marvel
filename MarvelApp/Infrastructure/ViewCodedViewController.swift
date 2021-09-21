//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by Gabriel Miranda Silveira on 16/09/21.
//

import UIKit


/// A ViewController class which helps to create a view coded layout
/// https://swiftrocks.com/writing-cleaner-view-code-by-overriding-loadview.html
class ViewCodedViewController<CustomView: BaseView>: UIViewController {
    var customView: CustomView {
        return view as! CustomView //It will never fail as we're overriding 'view'
    }

    override func loadView() {
        //Your custom implementation of this method should not call super.
        //https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview
        view = CustomView()
    }
}
