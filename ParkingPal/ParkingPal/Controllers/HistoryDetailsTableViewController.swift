//
//  HistoryDetailsTableViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 7/2/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

class HistoryDetailsTableViewController: UITableViewController {
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var parkingTypeLabel: UILabel!
    @IBOutlet weak var spaceNumberLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var timeOutLabel: UILabel!
    
    var parkingSpace: ParkingSpace? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func loadDetails(){
        guard let space = parkingSpace else{
            print("Error: No parking space history provided.")
            return
        }
        
        guard let location = space.spaceLocation else{
            print("Error: No location found with provided parking space.")
            return
        }
        
        companyLabel.text = location.title
        addressLabel.text = location.address
        parkingTypeLabel.text = ParkingType(rawValue: space.type)?.description()
        spaceNumberLabel.text = space.name != nil ? space.name : "N/A"
        floorLabel.text = space.floor != nil ? space.floor : "N/A"
        timeInLabel.text = space.timeIn?.description
        timeOutLabel.text = space.timeOut != nil ? space.timeOut?.description : "N/A"
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


}
