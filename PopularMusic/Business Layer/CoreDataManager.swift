//
//  CoreDataManager.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 26.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc class CoreDataManager: NSObject {
    
    //MARK: - Public Properties
    static var sharedInstance = CoreDataManager()
    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Private Properties
    private let containerName = "PopularMusicStorage"
    
    //MARK: - Public Methods
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func fetchEntity<T>(byId id: String) -> T? where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            guard result.count > 0 else { return nil }
            return result.first
        } catch {
            return nil
        }
    }
    
    func fetchEntitiesList<T>() -> [T]? where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            guard result.count > 0 else { return nil }
            return result
        } catch {
            return nil
        }
    }
    
}
