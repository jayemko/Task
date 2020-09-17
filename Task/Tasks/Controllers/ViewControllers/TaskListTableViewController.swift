//
//  TaskListTableViewController.swift
//  Tasks
//
//  Created by Jason Koceja on 9/17/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TaskController.shared.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.shared.fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.fetchedResultsController.sections?[section].objects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let object = TaskController.shared.fetchedResultsController.sections?[section] else {return ""}
        return Int(object.name) == 0 ? "Incomplete" : "Complete"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else {return UITableViewCell()}
        let task = TaskController.shared.fetchedResultsController.object(at: indexPath)
        cell.update(withTask: task)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = TaskController.shared.fetchedResultsController.object(at:indexPath)
            TaskController.shared.removeTask(task: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        // indetifier
        if segue.identifier == "showTaskSegue" {
            // index
            guard let indexPath = tableView.indexPathForSelectedRow,
                // destination
                let destinationVC = segue.destination as? TaskDetailTableViewController else {return}
            // object to send
            let taskToSend = TaskController.shared.fetchedResultsController.object(at:indexPath)
            // objec to receive
            destinationVC.task = taskToSend
            destinationVC.dueDateValue = taskToSend.due
        }
    }
}

extension TaskListTableViewController : ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender),
            let task = TaskController.shared.fetchedResultsController.sections?[indexPath.section].objects?[indexPath.row] as? Task else {return}
        TaskController.shared.toggleIsCompleteForTask(task: task)
        sender.update(withTask: task)
    }
}

extension TaskListTableViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move:
                break
            case .update:
                break
            @unknown default:
                fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else {return}
                tableView.insertRows(at: [newIndexPath], with: .fade)
            case .delete:
                guard let indexPath = indexPath else {return}
                tableView.deleteRows(at: [indexPath], with: .fade)
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else {return}
                tableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else {return}
                tableView.reloadRows(at: [indexPath], with: .fade)
            @unknown default:
                fatalError()
        }
    }
}
