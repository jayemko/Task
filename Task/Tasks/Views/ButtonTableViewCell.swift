//
//  ButtonTableViewCell.swift
//  Tasks
//
//  Created by Jason Koceja on 9/16/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var delegate: ButtonTableViewCellDelegate?
    
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.buttonCellButtonTapped(self)
    }
}

extension ButtonTableViewCell {
    func update(withTask task: Task){
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
    func updateButton(_ isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
        completeButton.tintColor = .systemBlue
    }
}
