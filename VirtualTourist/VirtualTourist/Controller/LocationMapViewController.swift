//
//  LocationMapViewController.swift
//  VirtualTourist
//
//  Created by Tianna Henry-Lewis on 2020-05-10.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class LocationMapViewController: UIViewController, MKMapViewDelegate {

    //MARK: - UI CONNECTIONS
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - VARIABLES
    //Injected DataController class
    var dataController: DataController!
    
    var savedPins : [Pin] = []
    var selectedPinLocation: Pin!

    
    var annotations = [MKPointAnnotation]()
    let pinReuseID = "pin"
    
    let segueID = "showAlbumSegue"
    
    
    
    //MARK: - LIFECYCLE METHODS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupGestureRecognizer()
        fetchSavedPins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Check if the mapView has been saved in UserDefaults and display that view
        if UserDefaultsClient.latitude != 0.0 {
            mapView.region = UserDefaultsClient.savedMapView
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       navigationController?.navigationBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // inject pin and dataController to ViewController
      let destinationVC = segue.destination as! PinAlbumViewController
      destinationVC.pin = selectedPinLocation
      destinationVC.dataController = dataController
    }
    
    //MARK: - GESTURE
    //Setup the gesture recognizer so the app will know when the user long presses on the map
    func setupGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnMap(_:)))
        longPress.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(longPress)
    }
    
    
    //Drop a Pin on the map where the user long presses, save that Pin into CoreData
    @objc func longPressOnMap(_ gestureRecognizer : UIGestureRecognizer) {
        if gestureRecognizer.state != .began { return }
        
        print("Long Press Recognized")
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        //TODO: Save Pin to CoreData
        savePin(latitude:
            touchMapCoordinate.latitude,
            longitude: touchMapCoordinate.longitude,
            creationDate: Date()
        )
    
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(annotation)
    }
    
    
    //MARK: - METHODS
    func fetchSavedPins() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            //If request is successful store the result in the savedPins array
            savedPins = result
            
            //Display the pins on the map
            let annotations = result.map { createAnnotations(latitude: $0.latitude, longitude: $0.longitude)}
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(annotations)
        }
    }
    
    func createAnnotations(latitude: Double, longitude: Double) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return annotation
    }
    
    func savePin(latitude: Double, longitude: Double, creationDate: Date) {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = latitude
        pin.longitude = longitude
        pin.creationDate = creationDate
        
        try? dataController.viewContext.save()
    }
    
    
    //MARK: - MAPKIT METHODS
    //Action to be performed when a pin is tapped
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // find which pin was tapped (at annotation latitude and longitude)
        selectedPinLocation = savedPins.filter({ $0.latitude == view.annotation?.coordinate.latitude && $0.longitude == view.annotation?.coordinate.longitude }).first
        
        //Segue to the album view
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //Save the map position and zoom level to UserDefaults
        UserDefaultsClient.savedMapView = mapView.region
    }

}

//pins.filter({ $0.coordinate.latitude == view.annotation?.coordinate.latitude && $0.coordinate.longitude == view.annotation?.coordinate.longitude }).first

//let annotations = result.map { createAnnotations(latitude: $0.latitude, longitude: $0.longitude)}
