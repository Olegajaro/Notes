//
//  UIView+Extensions.swift
//  Notes
//
//  Created by Олег Федоров on 25.02.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func rootView() -> UIView {
        var view = self
        
        while view.superview != nil {
            view = view.superview ?? UIView()
        }
        
        return view
    }
    
    var isOnWindow: Bool {
        return rootView() is UIWindow
    }
}
