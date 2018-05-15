//
//  SetLocationDetailsTableViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/12/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

protocol SetLocationDetailsTableDelegate{
    func showSpaceInfo()
    func showSelectFloor()
    func showSpaceExpirationInfo()
    func spaceNameUpdated(name: String?)
    func spaceFloorUpdated(floor: String?)
    func spaceExpirationUpdated(expires: Date?)
    func clearSpaceNumber()
}

class SetLocationDetailsTableViewController: UITableViewController, SpaceNumberDelegate, SpaceFloorDelegate, SpaceExpirationDelgate {
    

    @IBOutlet weak var spaceNameLabel: UILabel!
    @IBOutlet weak var spaceFloorLabel: UILabel!
    @IBOutlet weak var spaceExpirationLabel: UILabel!
    
    
    var delegate: SetLocationDetailsTableDelegate? = nil
    
    var sourceName: String? = nil
    var sourceSuffixList: [String] = [String]()
    var spaceName: String?{
        didSet{
            delegate?.spaceNameUpdated(name: self.spaceName)
        }
    }
    
    var sourceFloor: String?{
        didSet{
            delegate?.spaceFloorUpdated(floor: self.sourceFloor)
        }
    }
    var sourceExpiration: Date?{
        didSet{
            delegate?.spaceExpirationUpdated(expires: self.sourceExpiration)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            delegate?.showSpaceInfo()
        }
        else if indexPath.row == 1{
            delegate?.showSelectFloor()
        }
        else if indexPath.row == 2{
            delegate?.showSpaceExpirationInfo()
        }
    }
    
    
    //MARK: SpaceNumberDelegate
    //*******************************
    
    func spaceNameUpdated(space: String) {
        sourceName = space
        
        updateSpaceNameFromSource()
    }
    
    func spaceSuffixUpdated(suffixList: [String]) {
        sourceSuffixList = suffixList
        
        updateSpaceNameFromSource()
    }
    
    func updateSpaceNameFromSource(){
        var suffixName = ""
        
        for suffix in sourceSuffixList{
            suffixName.append(suffix)
        }
        
        spaceName = (sourceName ?? "") + " " + suffixName
        
        spaceNameLabel.text = spaceName
    }
    
    func clearSpaceName() {
        sourceName = nil
        sourceSuffixList = []
        spaceName = nil
        spaceNameLabel.text = "(None Specified)"
    }
    

    //MARK: SpaceFloorDelegate Methods
    //***********************************
    
    func spaceFloorUpdated(floor: String) {
        sourceFloor = floor
        spaceFloorLabel.text = floor
    }
    
    func clearSpaceFloor() {
        sourceFloor = nil
        spaceFloorLabel.text = "(None Specified)"
    }

    
    //MARK: SpaceExpirationDelegate Methods
    //*****************************************
    
    func updateExpiration(date: Date) {
        sourceExpiration = date
        spaceExpirationLabel.text = date.description
    }
    
    func clearExpireDate() {
        sourceExpiration = nil
        spaceExpirationLabel.text = "(None Specified)"
    }
    
}
