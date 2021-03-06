//
//  DataStore.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Ryan Cohen on 7/22/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class DataStore {
    
    enum EngineType: String {
        case Sail
        case Gas
        case Electric
    }
    
    var pirates: [Pirate] = []
    static let sharedInstance = DataStore()
    
    // MARK: - Convenience
    
    func addPirate(name: String) {
        let pirate: Pirate = insertNewPirateObject()
        pirate.name = name;
        
        saveContext()
    }
    
    func addShip(name: String, engineType: EngineType, pirate: Pirate) {
        let engine: Engine = insertNewEngineObject()
        engine.propulsionType = engineType.rawValue
        
        let ship: Ship = insertNewShipObject()
        ship.name = name
        ship.engine = engine
        ship.pirate = pirate
        
        saveContext()
    }

    // MARK: - Functions
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Error: \(error): \(error.userInfo)")
                abort()
            }
        }
        
        fetchData()
    }
    
    func fetchData() {
        let pirateRequest = NSFetchRequest(entityName: "Pirate")
        
        do {
            pirates = try managedObjectContext.executeFetchRequest(pirateRequest) as! [Pirate]
        } catch let error as NSError {
            print("Error: \(error): \(error.userInfo)")
            pirates = []
        }
        
        if pirates.count == 0 {
            buildShip()
        }
    }
    
    // MARK: - Helpers
    
    func insertNewPirateObject() -> Pirate {
        let pirate: Pirate = NSEntityDescription.insertNewObjectForEntityForName("Pirate", inManagedObjectContext: managedObjectContext) as! Pirate
        
        return pirate
    }
    
    func insertNewEngineObject() -> Engine {
        let engine: Engine = NSEntityDescription.insertNewObjectForEntityForName("Engine", inManagedObjectContext: managedObjectContext) as! Engine
        
        return engine
    }
    
    func insertNewShipObject() -> Ship {
        let ship: Ship = NSEntityDescription.insertNewObjectForEntityForName("Ship", inManagedObjectContext: managedObjectContext) as! Ship
        
        return ship
    }
    
    func buildShip() {
        let pirate: Pirate = insertNewPirateObject()
        pirate.name = "Petey"
        
        let engine: Engine = insertNewEngineObject()
        engine.propulsionType = "sail"
        
        let ship: Ship = insertNewShipObject()
        ship.name = "Petey's Sick Boat"
        ship.engine = engine
        ship.pirate = pirate
        
        saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("swift_captain_morgans_relationships_lab", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CaptainMorgan.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //MARK: - Application's Documents directory
    // Returns the URL to the application's Documents directory.
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FlatironSchool.SlapChat" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
}
