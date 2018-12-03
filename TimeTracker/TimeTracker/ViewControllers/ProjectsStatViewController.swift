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
    
    var dataController: DataController!
    var items: [ProjectItem] = []
    
    let ref = Database.database().reference(withPath: "project-list")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        ref.observe(.value, with: { snapshot in
            print("snapshot observed")
            // 2
            var newItems: [ProjectItem] = []
            
            // 3
            for child in snapshot.children {
                // 4
                if let snapshot = child as? DataSnapshot,
                    let projectItem = ProjectItem(snapshot: snapshot) {
                    print("projectItem(\(projectItem.name), \(projectItem.totalDuration))")
                    newItems.append(projectItem)
                }
            }
            
            // 5
            self.items = newItems
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
//        print("display projectItem(\(projectItem.name), \(projectItem.totalDuration))")
        cell.textLabel?.text = projectItem.name
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = String(projectItem.totalDuration)
                    }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let aProject = fetchedResultsController.object(at: indexPath)
        let projectItem = items[indexPath.row]
        
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"name == %@", projectItem.name)
        if let result = try? dataController.viewContext.fetch(fetchRequest) {

            let projectController = self.storyboard!.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
            projectController.dataController = dataController
            projectController.project = result[0]
            self.present(projectController, animated: true, completion: nil)

        } // handle fetch error
        
        
    }
}
    

