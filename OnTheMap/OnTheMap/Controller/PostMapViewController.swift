//
//  PostMapViewController.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-05-01.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PostMapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - STORYBOARD CONNECTIONS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    //MARK: - VARIABLES
    var userLocation: Location?
    let reuseId = "pin"
    
    let unwindSegueID = "unwindToMap"

    
    //MARK: - LIFECYCLE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        submitButton.isEnabled = false
        
        UdacityAPIClient.getUserData(completion: handleUserDataResponse(success:error:))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let location = userLocation {
            showLocationOnMap(location: location)
        }
    }
    
    //MARK: - MAPVIEW CONFIGURATION
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.markerTintColor = UIColor(named: "accentPurple")
            pinView!.tintColor = UIColor(named: "secondaryPurple")
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let url = ((view.annotation?.subtitle) ?? "") ?? ""
            
        if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                showAlert(title: "Invalid URL", message: "Sorry but the URL that was supplied is not a valid URL")
            }
        }
    }
    

    //MARK: - UI-DRIVEN FUNCTIONS
    @IBAction func cancelButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: unwindSegueID, sender: self)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let location = self.userLocation else { return }
        
        UdacityAPIClient.postLocation(location: location.location, link: location.link, latitude: location.latitude, longitude: location.longitude, completion: self.handlePostResponse(success:error:))
    }
    
    
    //MARK: - FUNCTIONS
    func showLocationOnMap(location: Location) {
        mapView.removeAnnotations(mapView.annotations)

        let lat = CLLocationDegrees(location.latitude)
        let long = CLLocationDegrees(location.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(location.location)"
        annotation.subtitle = location.link
    
        mapView.addAnnotation(annotation)
        
        // zoom to user location
        let regionRadius: CLLocationDistance = 10000
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(viewRegion, animated: false)
        submitButton.isEnabled = true
    }
    
    func handlePostResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                self.performSegue(withIdentifier: self.unwindSegueID, sender: nil)
            } else {
                if let error = error {
                    self.showAlert(title: "Post Location Failed", message: error.localizedDescription)
                }
            }

        }
    }
    
    func handleUserDataResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                self.submitButton.isEnabled = true
            } else {
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}
