//
//  ProjectViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 10/23/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseDatabase

class ProjectViewController : UIViewController {
    
    //FirebaseDatabase
    var db: DatabaseReference!
    // DataController property
    var dataController:DataController!
    var project: Project?
    var time = 0
    var timer = Timer()
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = project?.name
        // creat a Connection to Firebase
        db = Database.database().reference(withPath: "project-list")
    }
    
    @IBAction func StartTimer(_ sender: UIButton) {
        //scheduledTimer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ProjectViewController.Action), userInfo: nil, repeats: true)
        startButton.isEnabled = false
    }
    
    @IBAction func PauseTimer(_ sender: UIButton) {
        timer.invalidate()
        startButton.isEnabled = true
    }
    @IBAction func StopTimer(_ sender: UIButton) {
        startButton.isEnabled = true
        timer.invalidate()
        addTask(duration:Int32(time) )
        time = 0
        timeLabel.text = timeDisplay(time: Int32(time))
    }
    // add segue to Tab Bar Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? UITabBarController {
//            if let vc0 = vc.viewControllers![0] as? ProjectsStatViewController {
//                vc0.dataController = dataController
//            }
//            if let vc1 = vc.viewControllers![1] as? GoalsStatViewController {
//                vc1.dataController = dataController
//            }
//        }
        if let vc = segue.destination as? GoalsViewController {
            vc.dataController = dataController
            vc.project = project
        }
    }
    
    @objc func Action (){
        time += 1
        timeLabel.text = timeDisplay(time: Int32(time))
    }
    func timeDisplay (time : Int32)-> String {
        let seconds = time % 60
        let minutes = (time / 60)
        let result = String(format: "%02d:%02d", minutes, seconds)
        return result
    }
    
    func addTask (duration : Int32) {
        //  add task to persistent store
        let task = Task(context: dataController.viewContext)
        task.creationDate = Date ()
        task.duration = duration
        task.project = project
        project?.totalDuration += duration
        try? dataController.viewContext.save()
        
        // add totalDuration to FireBase
        let projectRef = self.db.child(project!.name!.lowercased())
        projectRef.setValue([
            "name": project!.name!,
            "total_duration": project!.totalDuration
            ])
    
        
    }

    
}
