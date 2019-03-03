//
//  ActiveParkingSpaceTableViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/30/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

class ActiveParkingSpaceTableViewController: UITableViewController {
    @IBOutlet weak var parkingTypeLabel: UILabel!
    @IBOutlet weak var parkingSpaceNameLabel: UILabel!
    @IBOutlet weak var parkingFloorLabel: UILabel!
    @IBOutlet weak var parkingExpirationLabel: UILabel!
    @IBOutlet weak var parkingAddressLabel: UILabel!
    
    var coreDataManager: CoreDataManager? = nil
    var currentParkingSpace: ParkingSpace? = nil
    
    var delegate: BaseLocationTrackingProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataManager = CoreDataManager(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer)
        loadSpaceInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    func loadSpaceInfo(){
        parkingTypeLabel.text = ParkingType(rawValue: (currentParkingSpace?.type)!)?.description()
        parkingSpaceNameLabel.text = currentParkingSpace?.name
        
        // Company
        navigationController?.navigationBar.topItem?.title = currentParkingSpace?.spaceLocation?.title
        
        // Address
        parkingAddressLabel.text = currentParkingSpace?.spaceLocation?.address
        
        // Floor
        if let floor = currentParkingSpace?.floor{
            parkingFloorLabel.text = floor
        }
        else{
            parkingFloorLabel.text = "None Specified"
        }
        
        // Expiration
        if let expiration = currentParkingSpace?.expireTime{
            parkingExpirationLabel.text = expiration.description
        }
        else{
            parkingExpirationLabel.text = "None Specified"
        }
    }
    
    
    //MARK: IBAction Methods
    //*******************************
    
    @IBAction func stopTrackingTouched(_ sender: Any) {
        coreDataManager?.stopTrackingLocation()
        delegate?.stopTrackingLocation()
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    //**********************************

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    

}
