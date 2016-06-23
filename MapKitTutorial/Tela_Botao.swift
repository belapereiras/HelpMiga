//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/23/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate{
    
    
    
// MARK: STORYBOARD

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var girl: UIImageView!
    @IBOutlet weak var helpMigaLabel: UIImageView!
    @IBAction func askHelp(sender: UIButton) {
        
        girl.hidden = true
        helpMigaLabel.hidden = true
//        helpButton.alpha = 0.5
        
        UserDAO.sharedInstace.saveAskHelp(Location.sharedInstace.lastLocation)
        addObservers()

    }
    
    func addObservers() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateLocation(_:)), name: "newLocation", object: nil)
    }
    
    func updateLocation(notification:NSNotification) {
        
        let lat = notification.userInfo!["lat"] as! Double
        let lng = notification.userInfo!["lng"] as! Double
        
        print("LATITUDE: \(lat) LONGITUDE: \(lng)")

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()

        checkLocationAuthorizationStatus()
        
        Location.sharedInstace.start()

        //tem que dar zoom no mapview
        
        
 
    }

   
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
            Location.sharedInstace.locationManager.startUpdatingLocation()
        } else {
            Location.sharedInstace.locationManager.requestWhenInUseAuthorization()
        }
    }
    

    
//MARK: ELEMENTOS INVISÍVEIS PARA VISÍVEIS
    
    override func viewWillAppear(animated: Bool) {
        helpButton.alpha = 0.0
        girl.alpha = 0.0
        helpMigaLabel.alpha = 0.0
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.helpButton.alpha = 1.0
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.girl.alpha = 1.0
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.helpMigaLabel.alpha = 1.0
            }, completion: nil)
    }    
}



