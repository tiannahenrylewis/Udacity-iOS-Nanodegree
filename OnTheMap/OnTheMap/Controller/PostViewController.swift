//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-05-01.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UINavigationBarDelegate {
    
    //MARK: - Storyboard Connections
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Add a Location"
        
    }
    
    
    
    //MARK: - UI-DRIVEN FUNCTIONS
    @IBAction func findLocationTapped(_ sender: Any) {
        performSegue(withIdentifier: "showMapPostSegue", sender: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("HELLO")
        navigationController?.popViewController(animated: true)
    }
    
}
