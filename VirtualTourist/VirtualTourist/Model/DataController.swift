//
//  DataController.swift
//  VirtualTourist
//
//  Created by Tianna Henry-Lewis on 2020-05-11.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation
import CoreData

//Core Data Stack setup and functionality that does three things:
//[1] - Hold a persistent container instance
//[2] - Load persistent container store
//[3] - Access the context
class DataController {
    
    //[1] - Hold a persistent container instance
    let persistentContainer: NSPersistentContainer
    
    //[3] - Access the context
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    //[2] - Load persistent container store
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
