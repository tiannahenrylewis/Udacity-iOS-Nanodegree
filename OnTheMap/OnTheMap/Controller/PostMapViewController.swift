//
//  PostMapViewController.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-05-01.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import MapKit

class PostMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - STORYBOARD CONNECTIONS
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - UI-DRIVEN ACTIONS
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
    }
    
}
