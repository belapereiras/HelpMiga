//
//  Location.swift
//  MapKitTutorial
//
//  Created by Priscila Rosa on 09/06/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    
    //acho q ele eh p pegar as coisas dos outros arquivos
    static let sharedInstace = Location()
    
    lazy var locationManager:CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 50
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    func start() {
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            print(#file, "starting to update locations")
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            
            print(#file, "starting to update locations")
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations.last)
//        UserDAO.sharedInstace.saveMyLocation(locations.last!)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(#file, error.localizedDescription)
    }
    
}