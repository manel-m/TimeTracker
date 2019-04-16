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
//import Firebase
//import FirebaseDatabase

class ProjectViewController : UIViewController {
    
    //FirebaseDatabase
    //var db: DatabaseReference!
    //  Core Data Controller
    var dataController:DataController!
    var project: Project?
    var timer = Timer()
    // delete this from here
    var hrs = 0
    var min = 0
    var sec = 0
//    var diffHrs = 0
//    var diffMins = 0
//    var diffSecs = 0
    // to here
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = project?.name
        // creat a Connection to Firebase
        //db = Database.database().reference(withPath: "project-list")
        // delete this forom here
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: .UIApplicationWillEnterForeground, object: nil)
        // to here
    }
    
    @IBAction func StartTimer(_ sender: UIButton) {
        //scheduledTimer
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ProjectViewController.Action), userInfo: nil, repeats: true)
        startButton.isEnabled = false
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ProjectViewController.updateLabels(t:))), userInfo: nil, repeats: true)
    }
    
    @IBAction func PauseTimer(_ sender: UIButton) {
        timer.invalidate()
        startButton.isEnabled = true
    }
    @IBAction func StopTimer(_ sender: UIButton) {
        startButton.isEnabled = true
        addTask(duration:Int32(self.sec + self.min*60 + self.hrs*3600) )
        self.resetContent()
    }
    
    // delete this function
    @objc func pauseWhenBackground(noti: Notification) {
        self.timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
    }
    // delete this fuction
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            var diffHrs, diffMins, diffSecs: Int
            (diffHrs, diffMins, diffSecs) = ProjectViewController.getTimeDifference(startDate: savedDate)
            
            self.refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
        }
    }
    // delete this function
    func resetContent() {
        self.removeSavedDate()
        timer.invalidate()
        self.timeLabel.text = "00:00:00"
        self.sec = 0
        self.min = 0
        self.hrs = 0
    }
    // delete this function
    @objc func updateLabels(t: Timer) {
        self.sec += 1
        if (self.sec == 60) {
            self.min += 1
            self.sec = 0
            if (self.min == 60) {
                self.hrs += 1
                self.min = 0
            }
        }
        displayTime()
    }
// delete this function
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    // delete this function
    func refresh (hours: Int, mins: Int, secs: Int) {
        self.sec += secs
        self.min += mins
        self.hrs += hours
        
        self.min += self.sec / 60
        self.sec = self.sec % 60
        self.hrs += self.min / 60
        self.min = self.min % 60

        displayTime()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ProjectViewController.updateLabels(t:))), userInfo: nil, repeats: true)
    }
    
    func displayTime() {
        self.timeLabel.text = String(format: "%02d:%02d:%02d", self.hrs, self.min, self.sec)
    }
    // delete this function
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    // add segue to Tab Bar Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoalsViewController {
            vc.dataController = dataController
            vc.project = project
        }
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
        //let projectRef = self.db.child(project!.name!.lowercased())
//        projectRef.setValue([
//            "name": project!.name!,
//            "total_duration": project!.totalDuration
//            ])
    }

    
}
