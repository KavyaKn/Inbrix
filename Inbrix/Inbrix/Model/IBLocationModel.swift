//
//  IBLocationModel.swift
//  Inbrix
//
//  Created by Kavya on 17/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBLocationModel: NSObject {
    
    var locationName: String?
    var locationId: String?
    var locationNumber: String?
    var latitude: NSNumber?
    var locationDistance: String?
    var longitude: NSNumber?
    
    override init() {
        super.init()
    }
    
    init(locationName: String, locationId: String, locationNumber: String){
        self.locationName = locationName
        self.locationId = locationId
        self.locationNumber = locationNumber
    }

}
