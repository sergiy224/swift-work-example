//
//  DataController.swift
//  Current Weather App
//
//  Created by Ruslan Ismayilov on 4/5/22.
//

import Foundation
import CoreData


class DataController{
    let persistentContainer : NSPersistentContainer
    
    var viewContext : NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName : String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
        
        func load(completion : (() -> Void)? = nil){
            persistentContainer.loadPersistentStores { storeDescription, error in
                guard error == nil else{
                    fatalError(error!.localizedDescription)
                }
                completion?()
            }
        }
    
}
