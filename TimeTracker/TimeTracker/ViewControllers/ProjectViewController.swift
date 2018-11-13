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
class ProjectViewController : UIViewController {
    var dataController:DataController!
    var projectName : String! = ""
    var project: Project?
    var time = 0
    // timer
    var timer = Timer()
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = projectName
        print(projectName)
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
        let duration = Int(timeLabel.text!)
        addTask(duration:Int32(duration!) )
        time = 0
        timeLabel.text = "0"//String(time)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoalsViewController {
            vc.dataController = dataController
            vc.project = project
            print("goals button segue")
        }
    }
    @objc func Action (){
        time += 1
        timeLabel.text = String(time)
    }
    
    func addTask (duration : Int32) {
        let task = Task(context: dataController.viewContext)
        task.creationDate = Date ()
        task.duration = duration
        task.project = project
        try? dataController.viewContext.save()
    }

    
}
