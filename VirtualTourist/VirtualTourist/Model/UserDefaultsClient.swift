//
//  UserDefaultsClient.swift
//  VirtualTourist
//
//  Created by Tianna Henry-Lewis on 2020-05-11.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation
import MapKit

class UserDefaultsClient {
    
    enum Keys: String {
       case latitude, longitude, latitudeDelta, longitudeDelta, firstLaunch
    }
    
    //In AppDelegate.swift, check if this is the first launch of the app and initialize default values
    class func checkIfFirstLaunch() {
       if UserDefaults.standard.bool(forKey: Keys.firstLaunch.rawValue) {
       } else {
        UserDefaults.standard.set(0.0, forKey: Keys.latitude.rawValue)
        UserDefaults.standard.set(0.0, forKey: Keys.longitude.rawValue)
        UserDefaults.standard.set(0.0, forKey: Keys.latitudeDelta.rawValue)
        UserDefaults.standard.set(0.0, forKey: Keys.longitudeDelta.rawValue)
        UserDefaults.standard.set(true, forKey: Keys.firstLaunch.rawValue)
       }
    }
    
    
    static var latitude: Double {
       get {
          return UserDefaults.standard.double(forKey: Keys.latitude.rawValue)
       }
       set(newValue) {
          UserDefaults.standard.set(newValue, forKey: Keys.latitude.rawValue)
       }
    }
    
    static var longitude: Double {
       get {
          return UserDefaults.standard.double(forKey: Keys.longitude.rawValue)
       }
       set(newValue) {
          UserDefaults.standard.set(newValue, forKey: Keys.longitude.rawValue)
       }
    }
    
    static var latitudeDelta: Double {
       get {
          return UserDefaults.standard.double(forKey: Keys.latitudeDelta.rawValue)
       }
       set(newValue) {
          UserDefaults.standard.set(newValue, forKey: Keys.latitudeDelta.rawValue)
       }
    }
    
    static var longitudeDelta: Double {
       get {
          return UserDefaults.standard.double(forKey: Keys.longitudeDelta.rawValue)
       }
       set(newValue) {
          UserDefaults.standard.set(newValue, forKey: Keys.longitudeDelta.rawValue)
       }
    }
    
    static var center: CLLocationCoordinate2D {
       get {
          return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
       }
       set (newCenter)  {
          self.latitude = newCenter.latitude
          self.longitude = newCenter.longitude
       }
    }
    
    static var span: MKCoordinateSpan {
       get{
          return MKCoordinateSpan(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta)
       }
       set (newSpan) {
          self.latitudeDelta = newSpan.latitudeDelta
          self.longitudeDelta = newSpan.longitudeDelta
       }
    }
    
    //Computed property for store and retrieve maps current view from user defaults
    static var savedMapView: MKCoordinateRegion {
        get {
            return MKCoordinateRegion(center: self.center, span: self.span)
        }
        set (newRegion) {
            self.center = newRegion.center
            self.span = newRegion.span
        }
    }
    
    
    
}
