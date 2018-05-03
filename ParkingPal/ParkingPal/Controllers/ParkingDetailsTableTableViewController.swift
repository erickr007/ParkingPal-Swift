//
//  ParkingDetailsTableTableViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 3/27/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import SVProgressHUD
import UIKit

protocol ParkingDetailsTableDelegate{
    func goToDetails()
    func locationTrackingStarted(space: ParkingSpace)
    func locationTrackingStopped()
}

class ParkingDetailsTableTableViewController: UITableViewController, SetLocationDelegate {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var parkingDescription: UILabel!
    @IBOutlet weak var parkingType: UILabel!
    @IBOutlet weak var setLocationButton: UIButton!
    
    var currentLocation: Location? = nil
    var activeParkingSpace: ParkingSpace? = nil
    var trackingCurrentLocation = false
    
    var delegate: ParkingDetailsTableDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SVProgressHUD.show()
        
        activeParkingSpace = CoreDataManager.getActiveParkingSpace()
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        //SVProgressHUD.dismiss()
    }
    
    func loadData(){
        if let space = activeParkingSpace{
            if space.spaceLocation?.address == currentLocation?.address {
                setLocationButton.setTitle("Stop Tracking", for: .normal)
                trackingCurrentLocation = true
            }
            else{
                setLocationButton.setTitle("Set Location", for: .normal)
                trackingCurrentLocation = false
            }
        }
    }
    
    //MARK:  SetLocationDelegate Methods
    //****************************************
    
    func newLocationSet(space: ParkingSpace) {
        activeParkingSpace = space
        loadData()
        
        delegate?.locationTrackingStarted(space: space)
    }
    

    @IBAction func setLocationTouched(_ sender: Any) {
        if trackingCurrentLocation == true{
            activeParkingSpace?.isActive = false
            
            CoreDataManager.saveContext()
            
            delegate?.locationTrackingStopped()
            
            navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        else{
            delegate?.goToDetails()
        }
    }
    

}
