//
//  ProjectsStatViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 11/2/18.
//  Copyright © 2018 udacity. All rights reserved.


import Foundation
import UIKit
import CoreData
//import Firebase
//import FirebaseDatabase

class ProjectsStatViewController : UITableViewController, NSFetchedResultsControllerDelegate {
    
    //  Core Data Controller
    var dataController: DataController!
    // add fetch results controller
    var fetchedResultsController: NSFetchedResultsController<Project>!
    //var items: [ProjectItem] = []
    
    // creat a Connection to Firebase
    //let ref = Database.database().reference(withPath: "project-list")
    
    // create activity indicators
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
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
//        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
       self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        setUpFetchedResultsController()
        // dedails of activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        // start activity indicator
        activityIndicator.startAnimating()
       
        // retrieve data in Firebase
//        ref.observe(.value, with: { snapshot in
//            //Store the latest version of the data in a local variable
//            var newItems: [ProjectItem] = []
//            
//            for child in snapshot.children {
//                
//                if let snapshot = child as? DataSnapshot,
//                    let projectItem = ProjectItem(snapshot: snapshot) {
//                    print("projectItem(\(projectItem.name), \(projectItem.totalDuration))")
//                    newItems.append(projectItem)
//                }
//            }
//            // Replace items with the latest version of the data
//            self.items = newItems
//            // reload the table view
//            self.tableView.reloadData()
//            self.activityIndicator.stopAnimating()
//        })
//        
//        // test Network connection
//        let connectedRef = Database.database().reference(withPath: ".info/connected")
//        connectedRef.observe(.value, with: { snapshot in
//            if snapshot.value as? Bool ?? false {
//                print("Connected")
//            } else {
//                print("Not connected")
//                self.displayError("Could not connected to Firebase")
//            }
//        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aProject = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
//       let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        // let projectItem = items[indexPath.row]
        // Set the name
        cell.textLabel?.text = aProject.name
        // Set the duration
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = timeDisplay(time: aProject.totalDuration)
                    }
        self.activityIndicator.stopAnimating()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let projectItem = items[indexPath.row]
        let aProject = fetchedResultsController.object(at: indexPath)
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.predicate = NSPredicate(format:"name == %@", aProject.name!)
        if let result = try? dataController.viewContext.fetch(fetchRequest) {

            let projectController = self.storyboard!.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
            projectController.dataController = dataController
            projectController.project = result[0]
            self.navigationController!.pushViewController(projectController, animated: true)
        } 
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let projectItem = items[indexPath.row]
//            projectItem.ref?.removeValue()
//        }
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
        
    }
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true, completion: nil)
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
    

