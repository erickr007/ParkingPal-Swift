//
//  MapFilterViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 3/12/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import CoreData
import UIKit

protocol MapFilterDelegate{
    func applyFilter(filter: MapFilter?)
}

class MapFilterViewController: UIViewController {

    var mapFilter: MapFilter? = nil
    var delegate : MapFilterDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load current filter
        
    }

    func loadFilter(){
        
    }

    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate?.applyFilter(filter: mapFilter)
        
        self.dismiss(animated: true, completion: nil)
    }
    

}

class MapFilter{
    var parkingType: ParkingType? = nil
    var distanceFromCurrentLocation: Double = 10
}

public enum ParkingType : Int32{
    case Street = 0
    case Structure = 1
    case Lot = 2
    case Residence = 3
    case Business = 4
    case Other = 5
    
    func description() -> String{
        switch(self.rawValue){
            case 0:
                return "Street"
            case 1:
                return "Structure"
            case 2:
                return "Lot"
            case 3:
                return "Residence"
            case 4:
                return "Business"
            case 5:
                return "Other"
            default:
                return "Unknown"
        }
    }
    
    static func getRawValue(name: String) -> Int32{
        switch(name){
        case "Street":
                return 0
        case "Structure":
                return 1
        case "Lot":
            return 2
        case "Residence":
            return 3
        case "Business":
            return 4
        case "Other":
            return 5
        default:
            return 5
        }
    }
    
    static func toList() -> [String]{
        let list = ["Street", "Structure", "Lot", "Residence", "Business", "Other", "Unknown"]
        
        return list
    }
}
