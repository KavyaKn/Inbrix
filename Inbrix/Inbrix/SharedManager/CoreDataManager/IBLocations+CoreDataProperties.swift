//
//  IBLocations+CoreDataProperties.swift
//  Inbrix
//
//  Created by Kavya on 20/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension IBLocations {

    @NSManaged var latitude: NSNumber?
    @NSManaged var locationDistance: String?
    @NSManaged var locationId: String?
    @NSManaged var locationNumber: String?
    @NSManaged var locationTitle: String?
    @NSManaged var longitude: NSNumber?

}
