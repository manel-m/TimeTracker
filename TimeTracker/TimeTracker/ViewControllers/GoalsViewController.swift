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
    
    //@IBOutlet weak var weeklyTextField: UITextField!
    
    func saveGoal () {
        let goal = Goal(context: dataController.viewContext)
        goal.creationDate = Date ()
        goal.project = project
        goal.dailyGoal = Int32(dailyTextField.text!)!
        try? dataController.viewContext.save()
}
    
    @IBAction func DoneButton(_ sender: UIButton) {
        let dailyGoal = dailyTextField.text
        if (dailyGoal?.isEmpty)!  {
            self.displayError("Empty Daily Goal")
        } else {
            saveGoal()
        }
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UITabBarController {
            if let vc0 = vc.viewControllers![0] as? ProjectsStatViewController {
                vc0.dataController = dataController
            }
            if let vc1 = vc.viewControllers![1] as? GoalsStatViewController {
                vc1.dataController = dataController
            }
        }
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
