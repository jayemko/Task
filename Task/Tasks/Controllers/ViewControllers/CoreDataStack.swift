//
//  CoreDataStack.swift
//  Tasks
//
//  Created by Jason Koceja on 9/16/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error [\(#function):\(#line)] -- \(error) \n---\n \(error.userInfo)")
            }
        }
        return container
    }()
    static var context: NSManagedObjectContext { return container.viewContext }
}
