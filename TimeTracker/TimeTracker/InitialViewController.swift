//
//  ViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 10/22/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        newProjectAlert()
    }
    
    func newProjectAlert() {
        let alert = UIAlertController(title: "New Project", message: "Enter a name for new Project", preferredStyle: .alert)
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let name = alert.textFields?.first?.text {
              //print(name)
                let projectVC = self.storyboard?.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
                projectVC.projectName = name
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


}

