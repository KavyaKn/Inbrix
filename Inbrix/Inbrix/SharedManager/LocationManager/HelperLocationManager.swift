//
//  HelperLocationManager.swift
//  Spotizen
//
//  Created by Pradeep Narendra on 4/7/16.
//  Copyright © 2016 Sakhatech. All rights reserved.
//

import UIKit
import CoreLocation

class HelperLocationManager: NSObject {
    
    var locationManager = CLLocationManager()
    static let sharedInstance = HelperLocationManager()
    var currentLocation :CLLocation?
    var notGotUserLocation = true
    
    override init() {
        super.init()
        
        let code = CLLocationManager.authorizationStatus()
        
        if code == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 50;
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension HelperLocationManager: CLLocationManagerDelegate{
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = locations.last
        print(locValue)
        self.currentLocation = locValue
        notGotUserLocation = false
        NSNotificationCenter.defaultCenter().postNotificationName("sendCurrentAddressToViewController", object:self.currentLocation)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Your error is ", error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}
