//
//  IBLocations.swift
//  Inbrix
//
//  Created by Kavya on 20/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation
import CoreData


class IBLocations: NSManagedObject {

    class func saveNearByPlaces(nearByPlaces : [IBLocationModel]) {
        
        for (_, nearByPlace) in nearByPlaces.enumerate() {
            let privateContext = CoreDataManager.sharedInstance.createPrivateContext()
            let resultPredicate = NSPredicate(format: "locationId == %@", nearByPlace.locationId)
            let  (array, _) = CoreDataManager.sharedInstance.fetchRequest("IBLocations", predicate: resultPredicate, sortDescriptors: nil, context: privateContext)
            if let array = array {
                if (array.count == 0) {
                    let nearByLocations = NSEntityDescription.insertNewObjectForEntityForName("IBLocations", inManagedObjectContext: privateContext) as! IBLocations
                    
                    //set image data of fullres
                    nearByLocations.locationTitle = nearByPlace.locationTitle
                    nearByLocations.locationDistance = nearByPlace.locationDistance
                    nearByLocations.latitude = nearByPlace.latitude
                    nearByLocations.longitude = nearByPlace.longitude
                    nearByLocations.locationId = nearByPlace.locationId
                    nearByLocations.locationNumber = nearByPlace.locationNumber
                    CoreDataManager.sharedInstance.saveContext(privateContext)
                }
            }
        }
    }
    
    class func fetchNearByPlaces() -> [IBLocations]? {
        
        let privateContext = CoreDataManager.sharedInstance.managedObjectContext
        let  (result, error) = CoreDataManager.sharedInstance.fetchRequest("IBLocations", predicate: nil, sortDescriptors: nil, context: privateContext)
        if (error != nil) {
            print(error?.userInfo)
        }
        return result as? [IBLocations]
    }
//
//    //Add near by location Images
//    
//    
//    class func fetchNearByLocationWithId(nearByPlaceId: String) -> IBNearByLocations {
//        
//        let privateContext = CoreDataManager.sharedInstance.managedObjectContext
//        let resultPredicate = NSPredicate(format: "locationId == %@", nearByPlaceId)
//        let  (result, error) = CoreDataManager.sharedInstance.fetchRequest("IBNearByLocations", predicate: resultPredicate, sortDescriptors: nil, context: privateContext)
//        if (error != nil) {
//            print(error?.userInfo)
//        }
//        return (result?.first as? IBNearByLocations)!
//    }

}
