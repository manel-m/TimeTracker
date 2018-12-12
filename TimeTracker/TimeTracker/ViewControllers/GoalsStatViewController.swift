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
        super.viewDidLoad()
        setUpFetchedResultsController()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("goals_stat_view_will_appear")
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
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
        tableView.reloadData()
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
                let goalMinute = (goal.weeklyGoal)*3600
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}


