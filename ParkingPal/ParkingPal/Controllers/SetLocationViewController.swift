//
//  SetLocationViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/11/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import CoreData
import UIKit

protocol SetLocationDelegate{
    func newLocationSet(space: ParkingSpace)
}

class SetLocationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, SetLocationDetailsTableDelegate {

    @IBOutlet weak var parkingTypePicker: UIPickerView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: SetLocationDelegate? = nil
    var currentLocation: Location? = nil
    var detailsTableVC: SetLocationDetailsTableViewController? = nil
    
    var parkingSpaceName: String? = nil
    var parkingSpaceFloor: String? = nil
    var parkingSpaceExpiration: Date? = nil
    var parkingTypeList: [String]? = nil
    var selectedType: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parkingTypePicker.dataSource = self
        parkingTypePicker.delegate = self
        parkingTypeList = ParkingType.toList()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedLocationDetailsTable"{
            detailsTableVC = segue.destination as? SetLocationDetailsTableViewController
            detailsTableVC?.delegate = self
        }
        else if segue.identifier == "goToSpaceName" {
            let spaceNumberVC = segue.destination as! SpaceNumberViewController
            spaceNumberVC.delegate = detailsTableVC
            
            //- if name info already set then initialize SpaceNumberViewController with those values
            if let spaceNumber = detailsTableVC?.sourceName{
                spaceNumberVC.set(spaceNumber: spaceNumber, suffixes: detailsTableVC?.sourceSuffixList)
            }
        }
        else if segue.identifier == "goToSelectFloor" {
            let spaceFloorVC = segue.destination as! SpaceFloorViewController
            spaceFloorVC.delegate = detailsTableVC
        }
        else if segue.identifier == "goToSpaceExpiration" {
            let spaceExpireVC = segue.destination as! SpaceExpirationViewController
            spaceExpireVC.delegate = detailsTableVC
        }
    }
    
    func deactivateExistingParking(){
        //inactivate any active parking spaces prior to adding this space
        let request: NSFetchRequest<ParkingSpace> = ParkingSpace.fetchRequest()
        let predicate = NSPredicate(format:"isActive = true")
        request.predicate = predicate
        
        do{
            let activeParking: [ParkingSpace] = try context.fetch(request)
            
            for parking in activeParking {
                parking.isActive = false
            }
            
            try context.save()
        }
        catch{
            print("Error deactivating existing parking: \(error)")
        }
    }
    
    
    //MARK: UI Actions
    //*******************
    
    @IBAction func saveSpaceLocationTouched(_ sender: Any) {
        deactivateExistingParking()
        
        let space = ParkingSpace(context: context)
        
        space.name = parkingSpaceName
        space.timeIn = Date.init()
        space.isActive = true
        space.spaceLocation = currentLocation
        
        if let expiration = parkingSpaceExpiration{
                space.expireTime = expiration
        }
        if let floor = parkingSpaceFloor{
            space.floor = floor
        }
        if let type = selectedType{
                space.type = Int32(type)
        }
        
        
        do{
            
            try context.save()
        }
        catch{
            print("Error saving parking space \(error)")
        }
        
        delegate?.newLocationSet(space: space)
        
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: SetLocationDetailsTableDelegate
    //*****************************************
    
    func showSpaceInfo() {
        performSegue(withIdentifier: "goToSpaceName", sender: self)
    }
    
    func showSelectFloor() {
        performSegue(withIdentifier: "goToSelectFloor", sender: self)
    }
    
    func showSpaceExpirationInfo() {
        performSegue(withIdentifier: "goToSpaceExpiration", sender: self)
    }
    
    func spaceFloorUpdated(floor: String?) {
        parkingSpaceFloor = floor
    }
    
    func spaceNameUpdated(name: String?) {
        parkingSpaceName = name

    }
    
    func spaceExpirationUpdated(expires: Date?) {
        parkingSpaceExpiration = expires
    }
    
    func clearSpaceNumber() {
        //parkingSpaceName = nil
    }
    
    
    
    
    
    //MARK: UIPickerViewDataSource Methods
    //******************************************
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let types = parkingTypeList{
            return types.count
        }
        else{
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return parkingTypeList?[row]
    }

    
    //MARK: UIPickerViewDelegate Methdos
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = row
    }
}
