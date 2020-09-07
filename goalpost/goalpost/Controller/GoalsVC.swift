//
//  GoalsVC.swift
//  goalpost
//
//  Created by Penny on 31/8/20.
//  Copyright © 2020 Penny. All rights reserved.
//

import UIKit
import CoreData


// Make an app delegate that we can access from anywhere.
let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoView: UIView!
    
    // Something to hold the results that we fetch from core data
    var goals : [Goal] = []
    
    // Remember what action has just been performed
    private var lastActionPerformed : LastAction = LastAction.noAction
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
    }//viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check for any existing goals.
        fetchCoreDataObjects()
        // Reload it so we can see any changes immediately
        tableView.reloadData()
    }//viewWillAppear
    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete && goals.count >= 1 {
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
            }
        }
    }//fetchCoreDataObjects
    
    
    @IBAction func addGoalButtonWasPressed(_ sender: Any) {

        guard let createGoalVC = storyboard?.instantiateViewController(identifier: "CreateGoalVC") else {return}
        presentDetail(createGoalVC)
        setLastAction(.goalAdded)
    }//addGoalButtonWasPressed

    @IBAction func undoButtonWasPressed(_ sender: Any) {
        // At this point the only thing we can undo is the removal of a goal
        undoLastAction()
    }//undoButtonWasPressed
    
}//GoalsVC


extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }//numberOfSections
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }//numberOfRowsInSection
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell
            else { print("Table cell creation failed")
                   return GoalCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal : goal)
        print("Table cell created OK")

        return cell
        
    }//cellForRowAt
    
    // Allow the table to be editted
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }//canEditRowAt
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // We have a custom configuration so returning NONE in the style here.
        return .none
    }//editingStyleForRowAt
    
    // Add some actions to do if row is swiped from left to right.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // First up, lets add the ability to delete the row & associated data
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE", handler: { (action, sourceView, completionHandler) in
            print("Row to delete: \(indexPath.row)")
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        })

        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        // And for our second action, let's add the ability to add 1 to progress
        let addAction = UIContextualAction(style: .normal, title: "ADD 1") { (action, sourceView, completionHandler) in
            print("Incrementing progress at row: \(indexPath.row)")
            self.setProgress(atIndexPath: indexPath)
            // Only need to update this row
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }

        addAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [deleteAction,addAction])
        // Delete the row if you swipe fully
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        
        return swipeActionConfig
        
    }//trailingSwipeActionsConfigurationForRowAt
    

}//extension

extension GoalsVC {
    
    // Fetch any saved core data
    func fetch( completion : (_ complete : Bool) -> () ) {
      
        guard  let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<Goal>(entityName : "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched persistent data.")
            completion(true)
        } catch  {
            debugPrint("Could not fetch : \(error.localizedDescription)")
            completion(false)
        }
   
    }//fetch
    
    
    // Remove stored data
    func removeGoal(atIndexPath : IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.undoManager = UndoManager()
        managedContext.undoManager?.beginUndoGrouping()
        managedContext.delete(goals[atIndexPath.row])
        do {
            try managedContext.save()
            setLastAction(.goalDeleted)
            print("Goal deleted OK")
        } catch {
            debugPrint("Could not delete goal : \(error.localizedDescription)")
        }
    }//removeGoal
   
    
    // Increment the progress counter
    func setProgress(atIndexPath : IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let chosenGoal = goals[atIndexPath.row]
   
        // Increment the progress by 1 if it's less than the goal
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        
        // Save the changes back to core data
        do {
            try managedContext.save()
            setLastAction(.progressUpdated)
            print("Progress updated")
        } catch {
            debugPrint("Error updating progress \(error.localizedDescription)")
        }
        
    }//setProgress

    // Undo the removal of the goal
    func undoLastAction(){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        managedContext.undoManager?.endUndoGrouping()
        // Undo the last action
        managedContext.undoManager?.undo()
        do {
            try managedContext.save()
            // Reload the goal back onto the table
            fetchCoreDataObjects()
            tableView.reloadData()
            setLastAction(.undo)
            print("Undo Goal Delete Successful")
        } catch {
            debugPrint("Could not undo Delete Goal : \(error.localizedDescription)")
        }

    }//UndoRemoveGoal
    
    func setLastAction(_ lastActionWas : LastAction) {
        switch lastActionWas {
        case .goalDeleted:
            undoView.isHidden = false
        default:
            undoView.isHidden = true
        }
        lastActionPerformed = lastActionWas
    }//setLastAction
    
}//2nd extension
