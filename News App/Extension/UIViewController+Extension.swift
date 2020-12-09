//
//  UIViewController+Extension.swift
//  News App
//
//  Created by Deependra Dhakal on 09/12/2020.
//

import UIKit
extension UIViewController {
    
    //MARK:- Show Alert
    func showAlert(title: String, message : String, buttonTitle: String){
        let alertView: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.cancel)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
