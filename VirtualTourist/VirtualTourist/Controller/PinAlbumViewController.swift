//
//  PinAlbumViewController.swift
//  VirtualTourist
//
//  Created by Tianna Henry-Lewis on 2020-05-11.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PinAlbumViewController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - UI CONNECTIONS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var noImagesLabel: UILabel!
    
    //MARK: - VARIABLES
    var pin : Pin!
    var dataController : DataController!
    var fetchedResultsController : NSFetchedResultsController<Photo>!
    
    let cellReuseID = "photoAlbumCell"
    
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        noImagesLabel.isHidden = false
        
        setupFetchedResultsController()
        setupMapView()
        
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        setupCollectionViewLayout()
        
        fetchPhotos(at: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        fetchedResultsController = nil
    }
    
    //MARK: - COLLECTIONVIEW DATASOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //Set the collection views number of sections to the number of sections in the fetchedResultsController, default to 1 if this is nil
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! PhotoAlbumCollectionViewCell
        cell.imageView.image = UIImage(data: photo.imageData!)
        return cell
    }
    
    //MARK: - COLLECTIONVIEW DELEGATES
    var blocks = [BlockOperation]()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deletePhoto(at: indexPath)
        collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type{
        case .insert:
            blocks.append(BlockOperation { [unowned self] in
                self.albumCollectionView.insertItems(at: [newIndexPath!])
            })
        case .delete:
            blocks.append(BlockOperation {[unowned self] in
                self.albumCollectionView.deleteItems(at: [indexPath!])
            })
        case .update:
            blocks.append(BlockOperation {[unowned self] in
                self.albumCollectionView.reloadItems(at: [indexPath!])
            })
        case .move:
            fallthrough
        default:
            fatalError("Invalid Chane type in controller.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blocks.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        albumCollectionView.performBatchUpdates({
            blocks.forEach { $0.start() }
        }, completion: nil)
    }
    
    
    
    //MARK: - UI-DRIVEN ACTIONS
    @IBAction func newCollectionTapped(_ sender: Any) {
        self.newCollectionButton.isEnabled = false
        
        pin.removeFromPhotos(pin.photos!)
        
        for _ in 0..<25 {
            let photo = Photo(context: dataController.viewContext)
            pin.addToPhotos(photo)
        }
        
        try? dataController.viewContext.save()
        
        fetchPhotos(at: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude))
        
        DispatchQueue.main.async {
            self.albumCollectionView.reloadData()
        }
        
    }
    
    func configureLoadingUI(isLoading: Bool) {
        newCollectionButton.isEnabled = !isLoading
    }
    
    
    //MARK: - METHODS
    func setupFetchedResultsController() {
        let fetchRequest = createFetchRequest()
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to load data from memrory with error: \(error.localizedDescription)")
        }
    }
    
    func createFetchRequest(_ offset: Int? = nil) -> NSFetchRequest<Photo> {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        
        if let offset = offset {
            fetchRequest.fetchOffset = offset
        }
        return fetchRequest
    }
    
    func performFetch(offset: Int? = nil) -> [Photo]? {
        return try? dataController.viewContext.fetch(createFetchRequest(offset))
    }
    
    func setupMapView() {
        //Save the selected pins coordinates into an easy to access variable
        let pinCoordinates = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        
        //Set the maps view and zoom to show the selected pin
        mapView.region = MKCoordinateRegion(center: pinCoordinates, latitudinalMeters: CLLocationDistance(exactly: 1500)!, longitudinalMeters: CLLocationDistance(exactly: 1500)!)
        
        //Add the marker on the map at the selected pin location
        let annotation = MKPointAnnotation()
        annotation.coordinate = pinCoordinates
        mapView.addAnnotation(annotation)
    }
    
    func setupCollectionViewLayout() {
        let spacing: CGFloat = 5
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: 50, right: spacing)
        let numberOfItems: CGFloat = 3
        let itemSize = (width - (spacing * (numberOfItems+1))) / numberOfItems
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        albumCollectionView.collectionViewLayout = layout
    }
    
    func fetchPhotos(at location: CLLocationCoordinate2D) {
        //Configure Loading UI - Hide the newCollectionButton
        configureLoadingUI(isLoading: true)
        
        // get photos from a search querying the latitude and longitude
        FlickrAPIClient.fetchPhotos(fromLocation: (latitude: pin.latitude, longitude: pin.longitude)) { (success: Bool, error: Error?) in
            guard error == nil else {
                self.showAlert(title: "ERROR", message: error!.localizedDescription)
                return
            }
            
            FlickrAPIClient.Variables.fetchedPhotosResponses.forEach {
                FlickrAPIClient.downloadPhoto(photo: $0, completion: self.handleDownloadPhotoResponse(data:error:))                }
        }
        
        if FlickrAPIClient.Variables.fetchedPhotosResponses.count < 25 {
            let photos = self.performFetch(offset: FlickrAPIClient.Variables.fetchedPhotosResponses.count)
            photos?.forEach { self.dataController.viewContext.delete($0) }
        }
    }
    
    
    func handleDownloadPhotoResponse(data: Data?, error: Error?) {
        guard let data = data else {
            self.showAlert(title: "Error", message: error?.localizedDescription ?? "An error occured during photo download.")
            return
        }
        
        if let image = UIImage(data: data) {
            if let photos = performFetch() {
                if photos.count != 25 {
                    let newPhoto = Photo(context: dataController.viewContext)
                    newPhoto.image = image
                    pin.addToPhotos(newPhoto)
                }
                
                
                try? dataController.viewContext.save()
                
                if photos.first(where: {$0.placeholder}) == nil {
                    //Configure the UI - Unhide the newCollectionButton
                    configureLoadingUI(isLoading: false)
                    //Display the corrent state of the noImagesLabel
                    if FlickrAPIClient.Variables.fetchedPhotosResponses.count == 0 {
                        self.noImagesLabel.isHidden = false
                    } else {
                        self.noImagesLabel.isHidden = true
                    }
                    
                }
                //Reload the collection view to display the images
                DispatchQueue.main.async {
                    self.albumCollectionView.reloadData()
                }
            }
        }
    }
    
    func deletePhoto(at indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(photo)
        try? dataController.viewContext.save()
    }
    
}
