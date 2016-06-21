//
//  IBLocationImages+CoreDataProperties.swift
//  Inbrix
//
//  Created by Kavya on 10/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension IBLocationImages {

    @NSManaged var image: NSData?
    @NSManaged var imageAddedTime: NSDate?
    @NSManaged var imageId: String?
    @NSManaged var imageName: String?

}
