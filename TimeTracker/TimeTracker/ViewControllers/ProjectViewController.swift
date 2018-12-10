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
    
    var db: DatabaseReference!
    var dataController:DataController!
    var projectName : String! = ""
    var project: Project?
    var time = 0
    var timer = Timer()
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = projectName
        db = Database.database().reference(withPath: "project-list")
    }
    
    @IBAction func StartTimer(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ProjectViewController.Action), userInfo: nil, repeats: true)
        //scheduledTimer
    }
    
    @IBAction func PauseTimer(_ sender: UIButton) {
        timer.invalidate()
    }
    @IBAction func StopTimer(_ sender: UIButton) {
        timer.invalidate()
        addTask(duration:Int32(time) )
        time = 0
        //timeLabel.text = String(time) //"0"
        timeLabel.text = timeDisplay(time: Int32(time))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UITabBarController {
            if let vc0 = vc.viewControllers![0] as? ProjectsStatViewController {
                vc0.dataController = dataController
                //vc0.project = project
            }
            if let vc1 = vc.viewControllers![1] as? GoalsStatViewController {
                vc1.dataController = dataController
                //vc1.project = project
            }
        }
        if let vc = segue.destination as? GoalsViewController {
            vc.dataController = dataController
            vc.project = project
            print("goals button segue")
        }
    }
    
    @objc func Action (){
        time += 1
        timeLabel.text = timeDisplay(time: Int32(time))
        
//        let seconds = time % 60
//        let minutes = time / 60
//        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    func timeDisplay (time : Int32)-> String {
        let seconds = time % 60
        let minutes = time / 60
        let result = String(format: "%02d:%02d", minutes, seconds)
        
        return result
    }
    
    func addTask (duration : Int32) {
        let task = Task(context: dataController.viewContext)
        task.creationDate = Date ()
        task.duration = duration
        task.project = project
        project?.totalDuration += duration
        try? dataController.viewContext.save()
        
        let projectRef = self.db.child(project!.name!.lowercased())
        
        projectRef.observe(.value, with: { snapshot in
            print("project \(snapshot.value ?? nil)")
        })

        projectRef.setValue([
            "name": project!.name!,
            "total_duration": project!.totalDuration
            ])
    
        
    }

    
}
