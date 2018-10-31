//
//  ProjectViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 10/23/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import UIKit
class ProjectViewController : UIViewController {
    
    var projectName : String! = ""
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
        time = 0
        timeLabel.text = "0"
    }
    
    @objc func Action (){
        time += 1
        timeLabel.text = String(time)
    }
}
