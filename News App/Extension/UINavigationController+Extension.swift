//
//  UIDate+Extension.swift
//  News App
//
//  Created by Deependra Dhakal on 08/12/2020.
//

import UIKit

extension UINavigationController {
    enum NavBarTheme {
        case primaryTheme(_ textColor: UIColor = UIColor.white)
    }
    
    func setTheme(theme: NavBarTheme) {
        switch theme {
        case .primaryTheme(let color):
            let textAttributes = [NSAttributedString.Key.foregroundColor: color]
            self.navigationBar.titleTextAttributes = textAttributes
            self.navigationBar.isTranslucent = false
            self.navigationBar.tintColor = color
            self.navigationBar.barTintColor = .primaryColor
            self.navigationBar.shadowImage = UIImage()
        }
    }
    
    func removeBackTitle() {
        self.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}
