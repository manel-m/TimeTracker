//
//  GoalsViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 10/23/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import UIKit
class GoalsViewController : UIViewController {
    
    //  Core Data Controller
    var dataController:DataController!
    var project: Project?
    
    @IBOutlet weak var weeklyGoalTextField: UITextField!
    
   //  add Goal to persistent store
    func saveGoal (_ weeklyGoal: Int32) {
        let goal = Goal(context: dataController.viewContext)
        goal.creationDate = Date ()
        goal.project = project
        goal.weeklyGoal = weeklyGoal
        try? dataController.viewContext.save()
    }
    
    @IBAction func DoneButton(_ sender: UIButton) {
        let weeklyGoalTxt = weeklyGoalTextField.text
        if (weeklyGoalTxt?.isEmpty)!  {
            self.displayError("Empty Weekly Goal")
        } else if let weeklyGoal = Int32(weeklyGoalTxt!) {
            saveGoal(weeklyGoal)
            self.navigationController!.popViewController(animated: true)
        } else {
            self.displayError("Invalid Input")
        }
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
