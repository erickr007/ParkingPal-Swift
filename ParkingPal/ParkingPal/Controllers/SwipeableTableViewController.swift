//
//  SwipeableTableViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/17/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import SwipeCellKit
import UIKit

class SwipeableTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateRow(indexPath: IndexPath){ }
    
    //MARK: SwipeTableViewCellDelegate Methods
    //*********************************************
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") {
            (action, path) in
            self.updateRow(indexPath: path)
        }
        
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
    }

    // MARK: - Table view data source
    //************************************
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suffixCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }

    

}
