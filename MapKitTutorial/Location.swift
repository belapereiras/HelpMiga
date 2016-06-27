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
    
    //ele eh p pegar as coisas dos outros arquivos
    static let sharedInstace = Location()
    
    lazy var locationManager:CLLocationManager = {
        let manager = CLLocationManager()
//        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 50
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    var lastLocation = CLLocation()
    
    func start() {
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            print(#file, "starting to update locations")
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
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
        print ("ATUALIZANDO AS LOCATION")
        print(locations.last)
        lastLocation = locations.last!
        UserDAO.sharedInstace.saveMyLocation(locations.last!)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print ("ERRO NO LOCATION MANAGER")
        print(#file, error.localizedDescription)
    }
}