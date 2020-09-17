//
//  TaskDetailTableViewController.swift
//  Tasks
//
//  Created by Jason Koceja on 9/16/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDueTextField: UITextField!
    @IBOutlet weak var taskNotesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    // MARK: - Properties
    
    var task: Task? {
        didSet{
            updateViews()
        }
    }
    var dueDateValue: Date?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDueTextField.inputView = dueDatePicker
        updateViews()
    }
    
    // MARK: - Set up
    
    func updateViews(){
        guard let task = task, isViewLoaded else {return}
        title = task.name
        taskNameTextField.text = task.name
        taskDueTextField.text = (task.due as Date?)?.stringValue()
        taskNotesTextView.text = task.notes
    }
    
    // MARK: - IBActions
    
    @IBAction func saveBarButtonTapped(_ sender: Any) {
        guard let name = taskNameTextField.text,
            let notes = taskNotesTextView.text else {return}
        if let task = task {
            TaskController.shared.updateTask(task: task, name: name, notes: notes, due: dueDateValue ?? nil)
        }else{
            TaskController.shared.addTaskWith(name: name, notes: notes, due: dueDateValue ?? nil)
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cancelBarButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dueDateValue = sender.date
        taskDueTextField.text = dueDateValue?.stringValue()
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        taskNameTextField.resignFirstResponder()
        taskDueTextField.resignFirstResponder()
        taskNotesTextView.resignFirstResponder()
    }
}
