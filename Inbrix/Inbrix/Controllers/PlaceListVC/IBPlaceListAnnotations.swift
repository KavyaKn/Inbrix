//
//  IBPlaceListAnnotations.swift
//  Inbrix
//
//  Created by Kavya on 30/03/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class IBPlaceListAnnotations: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var locationId : String?
    var distance: String?
    
    override init() {
        coordinate = CLLocationCoordinate2D()
        super.init()
    }
    
    init(title: String, coordinate: CLLocationCoordinate2D, locationId : String, distance: String) {
        self.title = title
        self.coordinate = coordinate
        self.locationId = locationId
        self.distance = distance
    }
    
    var subtitle: String? {
        return locationId
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [String(kABPersonAddressStreetKey): self.subtitle  as! AnyObject]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }

}
