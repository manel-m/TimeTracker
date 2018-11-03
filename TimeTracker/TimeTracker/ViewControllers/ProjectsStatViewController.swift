//
//  ProjectsStatViewController.swift
//  TimeTracker
//
//  Created by Manel matougui on 11/2/18.
//  Copyright © 2018 udacity. All rights reserved.
//

import Foundation
import UIKit

class ProjectsStatViewController : UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell")!
//        let villain = self.allVillains[(indexPath as NSIndexPath).row]
        
        // Set the name and image
//        cell.textLabel?.text = villain.name
//        cell.imageView?.image = UIImage(named: villain.imageName)
        
        // If the cell has a detail label, we will put the evil scheme in.
//        if let detailTextLabel = cell.detailTextLabel {
//            detailTextLabel.text = "Scheme: \(villain.evilScheme)"
        
        return cell
    }
}
    

