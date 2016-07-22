//
//  IBLocationImages.swift
//  Inbrix
//
//  Created by Kavya on 10/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation
import CoreData


class IBLocationImages: NSManagedObject {

    class func addLocationImages(locationImageAssests : [IBLocationImageModel]) {
        
        let privateContext = CoreDataManager.sharedInstance.managedObjectContext
//        let nearByPlace = IBLocations.fetchNearByLocationWithId(locationId)
        for (_, imageModel) in locationImageAssests.enumerate() {
            let locationImage = NSEntityDescription.insertNewObjectForEntityForName("IBLocationImages", inManagedObjectContext: privateContext) as! IBLocationImages
            //set image data of fullres
            locationImage.imageId = imageModel.imageId
            locationImage.imageName = imageModel.imageName
            locationImage.image = imageModel.image
            locationImage.imageAddedTime = imageModel.imageAddedTime
            print(locationImage.imageId)
        }
        CoreDataManager.sharedInstance.saveContext(privateContext)
    }
}
