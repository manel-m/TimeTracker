//
//  ProjectItem.swift
//  TimeTracker
//
//  Created by Manel matougui on 12/2/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import Firebase

struct ProjectItem {
    let ref: DatabaseReference?
    let name: String
    let totalDuration: Int32
    
    init(name: String, totalDuration: Int32) {
        self.ref = nil
        self.name = name
        self.totalDuration = totalDuration
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String:AnyObject],
            let name = value["name"] as? String,
            let totalDuration = value["total_duration"] as? Int32 else {
            return nil
        }
        self.ref = snapshot.ref
        self.name = name
        self.totalDuration = totalDuration
    }
}
