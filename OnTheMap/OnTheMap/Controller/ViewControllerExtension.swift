//
//  ViewControllerExtension.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-05-03.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //Present the user with a custom Error Pop-up (UIAlertController)
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
