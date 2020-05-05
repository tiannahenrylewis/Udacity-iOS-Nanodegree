//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-05-01.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import CoreLocation

class PostViewController: UIViewController, UINavigationBarDelegate {
    
    //MARK: - STORYBOARD CONNECTIONS
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - VARIABLES
    let geocoder = CLGeocoder()
    let segueID = "showMapPostSegue"
    
    
    
    //MARK: - LIFECYCLE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Add a Location"
        activityIndicator.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            let postMapVC = segue.destination as! PostMapViewController
            let userLocation = sender as! Location
            postMapVC.userLocation = userLocation
        }
    }
    
    
    
    //MARK: - UI-DRIVEN FUNCTIONS
    @IBAction func findLocationTapped(_ sender: Any) {
        configureUI(searching: true)
        locateUser()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - FUNCTIONS
    func configureUI(searching: Bool) {
        if searching {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            locationTextField.isEnabled = false
            linkTextField.isEnabled = false
            submitButton.isEnabled = false
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            locationTextField.isEnabled = true
            linkTextField.isEnabled = true
            submitButton.isEnabled = true
        }
    }
    
    func validateLink(userLink: String?) -> Bool? {
        guard let link = userLink,
              let url = URL(string: link) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func showOnMap(coordinate: CLLocationCoordinate2D) {
        
        guard let userLocation = locationTextField.text else { return }
        guard let userLink = linkTextField.text else { return }
        

        let location = Location(location: userLocation, link: userLink, latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        performSegue(withIdentifier: segueID, sender: location)
    }
    
    func locateUser() {
        guard let location = locationTextField.text else {
            return
        }
        
//        if !validateLink(userLink: linkTextField.text) {
//            showAlert(title: "Add Location Failed", message: "Invalid URL")
//        }
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            //Return UI to normal state
            self.configureUI(searching: false)
            
            //Handle the Geocode Reponse
            if let error = error {
                self.showAlert(title: "Failed", message: "Unable to find a location for \(location)")
            } else {
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    print("Found your location: \(location)")
                    self.showOnMap(coordinate: location.coordinate)
                } else {
                    self.showAlert(title: "Failed", message: "Could not locate a match for \(String(describing: location ?? nil))")
                }
            }
        }
    }
    
    
    
    
}
