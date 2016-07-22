//
//  IBLocationImageModel.swift
//  Inbrix
//
//  Created by Kavya on 22/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation

class IBLocationImageModel {
    
    var image: NSData?
    var imageAddedTime: NSDate?
    var imageId: String?
    var imageName: String?
    
    class func initializeWithDictionary(response : Dictionary<String, AnyObject>) -> IBLocationImageModel {
        
        let imageModel = IBLocationImageModel()
        imageModel.image = response["imageData"] as? NSData
        imageModel.imageId = String(response["imageId"])
        imageModel.imageAddedTime = response["imageAddedTime"] as? NSDate
        imageModel.imageName = String(response["imageName"])
        return imageModel
    }
    
}