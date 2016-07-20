//
//  CoreDataManager.swift
//  MapunitGroup
//
//  Created by Subramanian on 4/21/16.
//  Copyright © 2016 Tarento Technologies Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    // MARK:- Configuration
    static let modelName = "Inbrix"
    static let storeName = "Inbrix.sqlite"
    
    // Lightweight migration
    static let storeOption = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Tarento-Technologies-Pvt-Ltd..core" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource(modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(storeName)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: storeOption)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: modelName, code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    init() {
        // subscribe to change notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CoreDataManager.mocDidSaveNotification(_:)), name:NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


// MARK: - Context
extension CoreDataManager {
    
    // MARK: - Context Observer
    dynamic func mocDidSaveNotification(notificaiton: NSNotification) {
        if let managedObjectContext = notificaiton.object as? NSManagedObjectContext {
            
            // ignore change notifications for the main context
            guard managedObjectContext != self.managedObjectContext else {
                return
            }
            
            guard managedObjectContext.persistentStoreCoordinator == self.managedObjectContext.persistentStoreCoordinator else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notificaiton)
            }
        }
    }
    
    // MARK: - Private Concurrency Context
    func createPrivateContext() -> NSManagedObjectContext {
        let privateManagedObjectContect = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateManagedObjectContect.persistentStoreCoordinator = self.persistentStoreCoordinator
        return privateManagedObjectContect
    }
    
    // MARK: - Private Concurrency Context
    func createChildContext() -> NSManagedObjectContext {
        let parentContext = self.managedObjectContext
        let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childContext.parentContext = parentContext
        return childContext
    }
    
    func createChildContext(parentContext: NSManagedObjectContext) -> NSManagedObjectContext {
        let parentContext = parentContext
        let childContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childContext.parentContext = parentContext
        return childContext
    }
    
    
    // MARK: - Core Data Saving support
    func saveContext (context: NSManagedObjectContext) -> NSError? {
        var saveContextError: NSError?
        if context.hasChanges {
            context.performBlockAndWait({
                do {
                    try context.save()
                } catch {
                    saveContextError = error as NSError
                }
            })
        }
        
        // If the context is child context the save the parent context changes also
        if let parentContext = context.parentContext where saveContextError == nil {
            if parentContext.hasChanges {
                parentContext.performBlockAndWait({
                    do {
                        try parentContext.save()
                    } catch {
                        saveContextError = error as NSError
                    }
                })
            }
        }
        return saveContextError
    }
}

// MARK: - Query
extension CoreDataManager {
    
    // MARK: - Fetch Request
    func fetchRequest(entity: String,
                      predicate: NSPredicate?,
                      sortDescriptors: [NSSortDescriptor]?,
                      context: NSManagedObjectContext) -> ( [NSManagedObject]? ,NSError?) {
        let fetchRequest = NSFetchRequest(entityName: entity)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        var requestError: NSError?
        var managedObjectList: [NSManagedObject]?
        
        context.performBlockAndWait(){
            do {
                try managedObjectList = context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            } catch {
                requestError = error as NSError
            }
        }
        return (managedObjectList, requestError)
    }
    
    // MARK: - Delete Request
    func deleteRequest (entity: String,
                        predicate: NSPredicate?,
                        context: NSManagedObjectContext) -> NSError? {
        
        let (managedObjectList, error) = fetchRequest(entity, predicate: predicate, sortDescriptors: nil, context: context)
        
        if let error = error {
            // Unable to fetch the request with the predicate.
            return error
        }
        
        var requestError: NSError?
        
        if let managedObjectList = managedObjectList {
            for managedObject in managedObjectList {
                context.deleteObject(managedObject)
                requestError = saveContext(context)
            }
        }
        return requestError
    }
    
    
    // MARK: - Delete Request With ManagedObject
    func deleteRequest (managedObjectList : [NSManagedObject],
                        context: NSManagedObjectContext) -> NSError? {
        var requestError: NSError?
        
        for managedObject in managedObjectList {
            context.deleteObject(managedObject)
            requestError = saveContext(context)
        }
        return requestError
    }
    
}