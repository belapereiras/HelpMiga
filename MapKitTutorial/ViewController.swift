//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/23/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
// MARK: STORYBOARD

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var helpButton: UIButton!
    
    
    @IBOutlet weak var girl: UIImageView!
   

    @IBOutlet weak var helpMigaLabel: UIImageView!
    
    
    @IBAction func askHelp(sender: UIButton) {
        
        girl.hidden = true
        helpMigaLabel.hidden = true
        
        
        helpButton.alpha = 0.5
        
        
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// MARK: MAP VIEW
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
}
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
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



