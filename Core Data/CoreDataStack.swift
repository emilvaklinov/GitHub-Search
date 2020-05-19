//
//  CoreDataStack.swift
//  GitHub Search
//
//  Created by Emil Vaklinov on 19/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import Foundation

import CoreData

class CoreDataStack {
    
    private init(){}
    
    static let shared = CoreDataStack()
    
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "GitHubData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }
    
    
}
