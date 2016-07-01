//
//  ViewController2.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/28/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit
import MapKit

class ViewController2: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var lat: Double?
    var long: Double?
    
// MARK: STORYBOARD
    
    @IBOutlet weak var fotoMigaEmPerigo: UIImageView!
    @IBOutlet weak var nomeMigaEmPerigo: UILabel!
    @IBOutlet weak var tempoParaMigaEmPerigo: UILabel!
    @IBOutlet weak var rotaParaMigaEmPerigo: MKMapView!
//    let locationManager = CLLocationManager()
    @IBAction func ligarParaMigaEmPerigo(sender: UIButton) {
        
        let numero: NSURL = NSURL(string: "tel://999645706")!
            UIApplication.sharedApplication().openURL(numero)
        
    }

    @IBAction func estouIndoMiga(sender: UIButton) {
        performSegueWithIdentifier("irParaMigaCaminho", sender: nil)
        
    }
    
    func updateLocation(notification:NSNotification) {
                
        print("CHEGOU NOTIFICAÇÃO \(long), \(lat)")
        dispatch_async(dispatch_get_main_queue(), {
        self.performSegueWithIdentifier("irParaMigaCaminho", sender: nil)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateLocation(_:)), name: "EstouIndo", object: nil)

        fotoMigaEmPerigo.layer.cornerRadius = fotoMigaEmPerigo.frame.size.width/2
        fotoMigaEmPerigo.clipsToBounds = true
        rotaParaMigaEmPerigo.layer.cornerRadius = rotaParaMigaEmPerigo.frame.size.width/12
        rotaParaMigaEmPerigo.clipsToBounds = true

        self.fotoMigaEmPerigo.layer.borderWidth = 4.0
        self.fotoMigaEmPerigo.layer.borderColor = UIColor.whiteColor().CGColor;

//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//        self.rotaParaMigaEmPerigo.showsUserLocation = true
        
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//        
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
//        
//        self.rotaParaMigaEmPerigo.setRegion(region, animated: true)
//        
//        self.locationManager.stopUpdatingLocation()
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Errors: " + error.localizedDescription)
//    }
    
}
    
    
    
    

    

