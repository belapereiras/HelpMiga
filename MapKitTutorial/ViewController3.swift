//
//  ViewController3.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/29/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit
import MapKit

class ViewController3: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
// MARK: STORYBOARD
    
    
    @IBOutlet weak var notificationBG: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
        let locationManager = CLLocationManager()

    @IBOutlet weak var miga: UIImageView!
    
    @IBOutlet weak var botaoLigar: UIButton!
        
    @IBAction func ligar(sender: UIButton) {

            
        let numero: NSURL = NSURL(string: "tel://995200650")!
            UIApplication.sharedApplication().openURL(numero)
    }
    
    
    
    @IBOutlet weak var botaoOk: UIButton!
    
    @IBAction func ok(sender: UIButton) {
        
        notificationBG.hidden = true
        miga.hidden = true
        botaoLigar.hidden = true
        botaoOk.hidden = true
        
        calmaMigaLabel.hidden = true
        nomeMigaLabel.hidden = true
        estaVindoLabel.hidden = true
        
    }
    
    
    @IBOutlet weak var calmaMigaLabel: UILabel!

    @IBOutlet weak var nomeMigaLabel: UILabel!
    
    @IBOutlet weak var estaVindoLabel: UILabel!
    
    
// MARK: BORDAS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        miga.layer.cornerRadius = miga.frame.size.width/2
        miga.clipsToBounds = true
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        self.miga.layer.borderWidth = 4.0
        self.miga.layer.borderColor = UIColor.whiteColor().CGColor;
        
    }
    
// MARK: MAP VIEW
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }

        
// MARK: ELEMENTOS INVISÍVEIS PARA VISÍVEIS

    override func viewWillAppear(animated: Bool) {
        
        notificationBG.alpha = 0.0
        
        miga.alpha = 0.0
        
        botaoLigar.alpha = 0.0
        
        botaoOk.alpha = 0.0
        
        calmaMigaLabel.alpha = 0.0
        
        nomeMigaLabel.alpha = 0.0
        
        estaVindoLabel.alpha = 0.0
        
    
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.notificationBG.alpha = 1.0
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.miga.alpha = 1.0
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.botaoLigar.alpha = 1.0
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.botaoOk.alpha = 1.0
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.calmaMigaLabel.alpha = 1.0
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.nomeMigaLabel.alpha = 1.0
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 2.0,
            options: [],
            animations: {
                self.estaVindoLabel.alpha = 1.0
            }, completion: nil)

    }
    
    
  
    
    
    
}
    



