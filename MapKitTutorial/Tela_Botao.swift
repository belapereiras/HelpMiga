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


class ViewController: UIViewController, MKMapViewDelegate {
    
    
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
        
//        let latHelp = notification.userInfo!["Lat"] as! Double
//        let lngHelp = notification.userInfo!["Long"] as! Double
        
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("irParaMiga", sender: notification)
        })
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) { // não seria performSegue ?
        
        if(segue.identifier == "irParaMiga") {
            
            if let lat = sender!.userInfo?["Lat"] as? Double {
                if let long = sender!.userInfo?["Long"] as? Double {
                    if let name = sender!.userInfo?["Nome"] as? String {
                        
                        let yourNextViewController = (segue.destinationViewController as! ViewController2)
                        yourNextViewController.lat = lat
                        yourNextViewController.long = long
                        yourNextViewController.userNome = name
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthorizationStatus()
//        addObservers()
        Location.sharedInstace.start()
//        Location.sharedInstace.locationManager.startUpdatingLocation()
//        let center = CLLocationCoordinate2D(latitude: Location.sharedInstace.lastLocation.coordinate.latitude, longitude: Location.sharedInstace.lastLocation.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
//        self.mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true


        let center = CLLocationCoordinate2D(latitude: Location.sharedInstace.lastLocation.coordinate.latitude, longitude: Location.sharedInstace.lastLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true

        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateLocation(_:)), name: "newHelp", object: nil)
        
    }

   
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
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



