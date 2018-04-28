//
//  SuffixTableViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/14/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

protocol SuffixTableViewDelegate {
    func updateSuffixList(list: [String])
}

class SuffixTableViewController: SwipeableTableViewController {

    var suffixList: [String] = []
    
    var delegate: SuffixTableViewDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suffixList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "suffixCell") as! UITableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = suffixList[indexPath.row]
        
        return cell
    }
    
    override func deleteRow(indexPath: IndexPath) {
        suffixList.remove(at: indexPath.row)
        
        delegate?.updateSuffixList(list: suffixList)
        //tableView.reloadData()
    }
    

}
