//
//  ProjectsStatViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 11/2/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseDatabase

class ProjectsStatViewController : UITableViewController {
    
    //  Core Data Controller
    var dataController: DataController!
    var items: [ProjectItem] = []
    
    // creat a Connection to Firebase
    let ref = Database.database().reference(withPath: "project-list")
    
    // function to convert seconds to minutes and hours
    func timeDisplay (time : Int32)-> String {
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hour = time / 3600
        let result = String(format: "%02d:%02d:%02d",hour, minutes, seconds)
        
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // retrieve data in Firebase
        ref.observe(.value, with: { snapshot in
            //Store the latest version of the data in a local variable
            var newItems: [ProjectItem] = []
            
            for child in snapshot.children {
                
                if let snapshot = child as? DataSnapshot,
                    let projectItem = ProjectItem(snapshot: snapshot) {
                    print("projectItem(\(projectItem.name), \(projectItem.totalDuration))")
                    newItems.append(projectItem)
                }
            }
            // Replace items with the latest version of the data
            self.items = newItems
            // reload the table view
            self.tableView.reloadData()
        })

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        let projectItem = items[indexPath.row]
        cell.textLabel?.text = projectItem.name
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = timeDisplay(time: projectItem.totalDuration)
                    }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let projectItem = items[indexPath.row]
        
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"name == %@", projectItem.name)
        if let result = try? dataController.viewContext.fetch(fetchRequest) {

            let projectController = self.storyboard!.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
            projectController.dataController = dataController
            projectController.project = result[0]
            self.navigationController!.pushViewController(projectController, animated: true)

        } 
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let projectItem = items[indexPath.row]
            projectItem.ref?.removeValue()
        }
    }
}
    

