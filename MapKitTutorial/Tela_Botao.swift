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
    }
    
    func addObservers() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateLocation(_:)), name: "newHelp", object: nil)
    }
    
    func updateLocation(notification:NSNotification) {
        
        let latHelp = notification.userInfo!["Lat"] as! Double
        let lngHelp = notification.userInfo!["Long"] as! Double


//        let nome = notification.userInfo!["Nome"] as! String

        print("CHEGOU NOTIFICAÇÃO, LATITUDE: \(latHelp) LONGITUDE: \(lngHelp)")
//        dispatch_async(dispatch_get_main_queue(), {
//        self.performSegueWithIdentifier("irParaBotao", sender: nil)
//        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthorizationStatus()
        //addObservers()
        Location.sharedInstace.start()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateLocation(_:)), name: "newHelp", object: nil)
    }

   
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            let center = CLLocationCoordinate2D(latitude: Location.sharedInstace.lastLocation.coordinate.latitude, longitude: Location.sharedInstace.lastLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
            self.mapView.setRegion(region, animated: true)
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



