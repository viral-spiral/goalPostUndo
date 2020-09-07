//
//  FinishGoalVC.swift
//  goalpost
//
//  Created by Penny on 1/9/20.
//  Copyright © 2020 Penny. All rights reserved.
//

import UIKit
import CoreData


class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createGoalButton: UIButton!
    @IBOutlet weak var actionsTextFiled: UITextField!
    
    var goalDescription : String!
    var goalType : GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionsTextFiled.delegate = self
        createGoalButton.bindToKeyboard()
    }//viewDidLoad
    

    func initData(description : String, type : GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    // Pass in a completion handler function that takes a boolean parameter to
    // indicate whether the save has completed and returns a function.
    func save(completion : (_ finished : Bool)->() ) {
        // Retrieve the app context
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        // Create an instance of our core data Goal, with the context so that it
        // knows where to save the data.
        let goal = Goal(context: managedContext)
        
        // Set up the model
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(actionsTextFiled.text!)!
        goal.goalProgress = Int32(0)

        // Pass the data to persistant storage
        do {
            try managedContext.save()
            print("Successfully saved data.")
            completion(true)
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
            completion(false)
        }
        
    }//save
    
    
    
    @IBAction func createGoalButtonWasPressed(_ sender: Any) {
        //Pass the data into the core data goal model.
        if actionsTextFiled.text != "" {
            self.save { (complete) in
                if complete { dismiss(animated: true, completion: nil) }
            }
        }
        
    }//createGoalButtonWasPressed
    
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismissDetail()
    }//backButtonWasPressed
    
}//FinishGoalVC
