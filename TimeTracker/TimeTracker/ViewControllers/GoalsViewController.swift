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
    
    var dataController:DataController!
    var project: Project?
    
    @IBOutlet weak var dailyTextField: UITextField!
    
    @IBOutlet weak var weeklyTextField: UITextField!
    
    func saveGoal () {
        let goal = Goal(context: dataController.viewContext)
        goal.creationDate = Date ()
        goal.project = project
        goal.dailyGoal = Int32(dailyTextField.text!)!
        goal.weeklyGoal = Int32(weeklyTextField.text!)!
}
    
    @IBAction func DoneButton(_ sender: UIButton) {
        saveGoal()
    }
}
