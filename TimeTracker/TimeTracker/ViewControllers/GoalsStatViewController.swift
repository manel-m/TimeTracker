//
//  GoalsStatViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 11/2/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import  UIKit
import CoreData
class GoalsStatViewController: UITableViewController , NSFetchedResultsControllerDelegate {
    
    //  Core Data Controller
    var dataController: DataController!
    // add fetch results controller
    var fetchedResultsController: NSFetchedResultsController<Project>!
    
    override func viewDidLoad() {
        print("goals_stat_view_did_load")
        super.viewDidLoad()
        setUpFetchedResultsController()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("goals_stat_view_did_disappear")
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
//        if let indexPath = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: indexPath, animated: false)
//            tableView.reloadRows(at: [indexPath], with: .fade)
//        }
    }

    fileprivate func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key : "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch cannot be perfrmed: \(error.localizedDescription)")
        }
    }
    func timeDisplay (time : Int32)-> String {
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hour = time / 3600
        let result = String(format: "%02d:%02d:%02d",hour, minutes, seconds)
        
        return result
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if let sections = fetchedResultsController.sections{
//            return sections.count
//        } else {
//            return 1
//        }
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aProject = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell")!
        
        // Set the name
        cell.textLabel?.text = aProject.name
        // Set the goal
        if let detailTextLabel = cell.detailTextLabel {
            if let goal = aProject.goal {
                let goalMinute = (goal.dailyGoal)*60
                detailTextLabel.text = timeDisplay(time:goalMinute)
            } else {
                detailTextLabel.text = "N/A"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aProject = fetchedResultsController.object(at: indexPath)

        let projectController = self.storyboard!.instantiateViewController(withIdentifier: "GoalsViewController") as! GoalsViewController
        projectController.dataController = dataController
        projectController.project = aProject
        self.navigationController!.pushViewController(projectController, animated: true)
        
    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let projectToDelete = fetchedResultsController.object(at: indexPath)
//            dataController.viewContext.delete(projectToDelete)
//            try? dataController.viewContext.save()
//        }
//    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteProject(at: indexPath)
        default: ()
        }
    }
    // Delete the project at the specified index path
    func deleteProject(at indexPath: IndexPath) {
        let projectToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(projectToDelete)
        try? dataController.viewContext.save()
        //tableView.reloadData()
        
    }
}

