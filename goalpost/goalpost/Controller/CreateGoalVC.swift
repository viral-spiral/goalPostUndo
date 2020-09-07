//
//  CreateGoalVC.swift
//  goalpost
//
//  Created by Penny on 31/8/20.
//  Copyright © 2020 Penny. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermButton: UIButton!
    @IBOutlet weak var longTermButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var goalType : GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.bindToKeyboard()
        shortTermButton.setSelectedColour()
        longTermButton.setDeselectedColour()
        goalTextView.delegate = self

    }//viewDidLoad
    
    
    @IBAction func nextButtonWasPressed(_ sender: Any) {
        if (goalTextView.text != "") && (goalTextView.text != "What is your goal?") {
            guard let finishGoalVC = storyboard?.instantiateViewController(identifier: "FinishGoalVC") as? FinishGoalVC else {return}
            finishGoalVC.initData(description: goalTextView.text, type: goalType)
            presentingViewController?.presentSecondaryDetail(finishGoalVC)
        }
    }//nextButtonWasPressed
    
    @IBAction func shortTermButtonWasPressed(_ sender: Any) {
        goalType = .shortTerm
        shortTermButton.setSelectedColour()
        longTermButton.setDeselectedColour()
    }//shortTermButtonWasPressed
    
    @IBAction func longTermButtonWasPressed(_ sender: Any) {
        goalType = .longTerm
        longTermButton.setSelectedColour()
        shortTermButton.setDeselectedColour()
    }//longTermButtonWasPressed
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismissDetail()
    }//backButtonWasPressed
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove any placeholder text just before we start editing.
        goalTextView.text = ""
        goalTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }//textViewDidBeginEditing

}//CreateGoalVC
