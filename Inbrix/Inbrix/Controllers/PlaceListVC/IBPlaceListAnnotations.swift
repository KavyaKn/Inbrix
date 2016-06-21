//
//  IBPlaceListAnnotations.swift
//  Inbrix
//
//  Created by Kavya on 30/03/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import MapKit

class IBPlaceListAnnotations: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var distance: String?
    
    override init() {
        coordinate = CLLocationCoordinate2D()
        super.init()
    }
    
    init(title: String, coordinate: CLLocationCoordinate2D, distance: String) {
        self.title = title
        self.coordinate = coordinate
        self.distance = distance
    }

}
