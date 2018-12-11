//
//  ViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 10/22/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase

class InitialViewController: UIViewController {
    
    //FirebaseDatabase
    var db: DatabaseReference!
    // Core Data Controller
    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // creat a Connection to Firebase
        db = Database.database().reference(withPath: "project-list")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // add segue to Tab Bar Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UITabBarController {
            // segue to ProjectsStatViewController
            if let vc0 = vc.viewControllers![0] as? ProjectsStatViewController {
                vc0.dataController = dataController
            }
            // segue to GoalsStatViewController
            if let vc1 = vc.viewControllers![1] as? GoalsStatViewController {
                vc1.dataController = dataController
            }
        }
    }
    
    // action to new project button
    @IBAction func addTapped(_ sender: Any) {
        newProjectAlert()
    }
    
    func newProjectAlert() {
        // create an alert
        let alert = UIAlertController(title: "New Project", message: "Enter a name for new Project", preferredStyle: .alert)
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            if let name = alert.textFields?.first?.text {
                let project = self.addProject(nameProject : name)
                let projectVC = self.storyboard?.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
                // passing project and dataController to the next viewController
                projectVC.project = project
                projectVC.dataController = self.dataController
                self.navigationController?.pushViewController(projectVC, animated: true)

            }
        }
        saveAction.isEnabled = false
        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "Project Name"
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    // add project to persistent store
    func addProject (nameProject : String)-> Project {
        let project = Project(context: dataController.viewContext)
        project.creationDate = Date()
        project.name = nameProject
        project.totalDuration = 0
        try? dataController.viewContext.save()
        
        // add project to FireBase
        let projectRef = self.db.child(nameProject.lowercased())
        // save data to the database.
        projectRef.setValue([
            "name": nameProject,
            "total_duration": project.totalDuration
        ])
        
        return project
    }

}

