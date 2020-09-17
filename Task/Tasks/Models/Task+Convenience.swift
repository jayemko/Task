//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Jason Koceja on 9/16/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    convenience init(name: String,notes: String?,due: Date?, isComplete: Bool, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = isComplete
    }
}
