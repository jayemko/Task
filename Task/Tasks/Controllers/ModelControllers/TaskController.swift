//
//  TaskController.swift
//  Tasks
//
//  Created by Jason Koceja on 9/16/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    static let shared = TaskController()
    
    var fetchedResultsController: NSFetchedResultsController<Task>
    
    init() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true),NSSortDescriptor(key: "name", ascending: true)]
        let moc = CoreDataStack.context
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "isComplete", cacheName: nil)
        fetchedResultsController = resultsController
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error [\(#function):\(#line)] -- \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    // MARK: - CRUD
    
    func addTaskWith(name: String,
                     notes: String?,
                     due: Date?) {
        _ = Task(name: name, notes: notes, due: due, isComplete: false)
        saveToPersistentStore()
    }
    
    func updateTask(task: Task,
                    name: String,
                    notes: String?,
                    due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStore()
    }
    
    func removeTask(task: Task) {
        CoreDataStack.context.delete(task)
        saveToPersistentStore()
    }
    // MARK: - Persistence
    
    func saveToPersistentStore(){
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error [\(#function):\(#line)] -- \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func toggleIsCompleteForTask(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistentStore()
    }
}
