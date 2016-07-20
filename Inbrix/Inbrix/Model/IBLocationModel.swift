//
//  IBLocationModel.swift
//  Inbrix
//
//  Created by Kavya on 17/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBLocationModel: NSObject {
    
//    var locationName: String?
//    var locationId: String?
//    var locationNumber: String?
//    var latitude: NSNumber?
//    var locationDistance: String?
//    var longitude: NSNumber?
//    
//    override init() {
//        super.init()
//    }
//    
//    init(locationName: String, locationId: String, locationNumber: String){
//        self.locationName = locationName
//        self.locationId = locationId
//        self.locationNumber = locationNumber
//    }
    
    var locationTitle: String = ""
    var locationDistance: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var locationId: String = ""
    var locationNumber: String = ""
    
    class func initializeWithDictionary(response : Dictionary<String, String>) -> IBLocationModel {
        
        let placeModel = IBLocationModel()
        placeModel.locationId = response["locationId"]!
        placeModel.locationTitle = response["locationTitle"]!
        placeModel.locationNumber = response["locationNumber"]!
        placeModel.latitude = Double(response["latitude"]!)!
        placeModel.longitude = Double(response["logitude"]!)!
        placeModel.locationDistance = response["locationDistance"]!
        return placeModel
    }


}
