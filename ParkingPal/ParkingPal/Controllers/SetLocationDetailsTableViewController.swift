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
    func spaceNameUpdated(name: String?)
    func spaceFloorUpdated(floor: String)
    func spaceRateUpdated(rate: String)
    func clearSpaceNumber()
}

class SetLocationDetailsTableViewController: UITableViewController, SpaceNumberDelegate {

    @IBOutlet weak var spaceNameLabel: UILabel!
    @IBOutlet weak var spaceFloorLabel: UILabel!
    @IBOutlet weak var spaceRateLabel: UILabel!
    
    
    var delegate: SetLocationDetailsTableDelegate? = nil
    
    var sourceName: String? = nil
    var sourceSuffixList: [String] = [String]()
    var spaceName: String?{
        didSet{
            delegate?.spaceNameUpdated(name: self.spaceName)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
