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
    
//    var project: Project?
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Project>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFetchedResultsController()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections{
            return sections.count
        } else {
            return 1
        }
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
                detailTextLabel.text = String(goal.dailyGoal)
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

//        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
//        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}

