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
    
    @IBOutlet weak var dailyTextField: UITextField!
    
   //  add Goal to persistent store
    func saveGoal (_ dailyGoal: Int32) {
        let goal = Goal(context: dataController.viewContext)
        goal.creationDate = Date ()
        goal.project = project
        goal.dailyGoal = dailyGoal
        try? dataController.viewContext.save()
    }
    
    @IBAction func DoneButton(_ sender: UIButton) {
        let dailyGoal = dailyTextField.text
        if (dailyGoal?.isEmpty)!  {
            self.displayError("Empty Daily Goal")
        } else if let dailyGoal = Int32(dailyTextField.text!) {
            saveGoal(dailyGoal)
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
