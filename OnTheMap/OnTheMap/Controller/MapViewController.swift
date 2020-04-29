//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-04-24.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: API Stuff
    //TODO: Move to a seperate file 
    
    //MARK: - Variables
    
    
    //MARK: - Storyboard Connections
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: - Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //ParseAPI.shared.request100StudentLocations()
    }
    

    
    //MARK: - Fucntions
 
}
