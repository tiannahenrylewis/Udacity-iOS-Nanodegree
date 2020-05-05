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
    
    //MARK: - Variables
    var annotations = [MKPointAnnotation]()
    let reuseId = "pin"
    
    //MARK: - Storyboard Connections
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: - Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        //Make a GET request to the API to get a list of 100 student locations and show on map
        //getStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStudentLocations()
    }
    
    //MARK: - MapView Functions
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
            let invalidUrlAC = UIAlertController(title: "Invalid URL", message: "Sorry but the URL that was supplied is not a valid URL", preferredStyle: .alert)
            invalidUrlAC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(invalidUrlAC, animated: true)
            }
        }
    }
    
    //MARK: - UI-DRIVEN FUNCTIONS
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UdacityAPIClient.logout(completion: handleLogoutResponse(success:error:))
    }
    @IBAction func pinButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addPinSegue", sender: self)
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        var annotations = [MKPointAnnotation]()
        for location in UdacityAPIClient.Variables.studentLocations {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    
    //MARK: - Fucntions
    func handleLogoutResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(title: "Logout Error", message: "Connection lost and unable to process logout request")
            }
        }
    }
    
    //TODO: - Use a loading indicator to alert the user that something is happening so the don't think the app is broken
    func getStudentLocations() {
        UdacityAPIClient.getStudentLocations(completion: handleStudentLocationsResponse(success:error:))
    }
    
    func handleStudentLocationsResponse(success: Bool, error: Error!) {
        if success {
            populateMap()
        } else {
            self.showAlert(title: "Download Failed", message: error.localizedDescription)
        }
    }
    
    func populateMap() {
        for student in UdacityAPIClient.Variables.studentLocations {
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    
    
    
    
}
