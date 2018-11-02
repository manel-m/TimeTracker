//
//  DataController.swift
//  TimeTracker
//
//  Created by Manel matougui on 10/30/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import CoreData
class DataController {
    
    let persistentContainer :NSPersistentContainer
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    func load (completion: (() -> Void )? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, Error in
            guard Error == nil else {
                fatalError(Error!.localizedDescription)
            }
        }
        completion?()
    }
    
    
    
}
