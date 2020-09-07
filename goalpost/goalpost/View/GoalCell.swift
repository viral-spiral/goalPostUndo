//
//  GoalCell.swift
//  goalpost
//
//  Created by Penny on 31/8/20.
//  Copyright © 2020 Penny. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var goalTypeLabel: UILabel!
    @IBOutlet weak var goalProgressLabel: UILabel!
    @IBOutlet weak var completionView: UIView!
    
    func configureCell( goal : Goal )
    {
        self.goalDescriptionLabel.text = goal.goalDescription
        self.goalTypeLabel.text = goal.goalType
        self.goalProgressLabel.text = String(describing: goal.goalProgress)
        
        // Have we completed our goal?
        if goal.goalProgress == goal.goalCompletionValue {
            self.completionView.isHidden = false
        } else {
            self.completionView.isHidden = true
        }
        
    }//configureCell
    
    
}//GoalCell
