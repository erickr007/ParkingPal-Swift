//
//  SetLocationViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/11/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import CoreData
import UIKit

class SetLocationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, SetLocationDetailsTableDelegate {

    @IBOutlet weak var parkingTypePicker: UIPickerView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var detailsTableVC: SetLocationDetailsTableViewController? = nil
    
    var parkingSpaceName: String? = nil
    var parkingSpaceFloor: String? = nil
    var parkingSpaceRate: String? = nil
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
    }
    
    @IBAction func saveSpaceLocationTouched(_ sender: Any) {
                let space = ParkingSpace(context: context)
                space.name = parkingSpaceName
        space.rate = parkingSpaceRate
        
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
                    print("Error save parking space \(error)")
                }
        
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: SetLocationDetailsTableDelegate
    //*****************************************
    
    func showSpaceInfo() {
        performSegue(withIdentifier: "goToSpaceName", sender: self)
    }
    
    func spaceFloorUpdated(floor: String) {
        
    }
    
    func spaceNameUpdated(name: String?) {
        parkingSpaceName = name

    }
    
    func spaceRateUpdated(rate: String) {
        
    }
    
    func clearSpaceNumber() {
        //parkingSpaceName = nil
    }
    
    //MARK: SpaceInfoDelegate Methods
    //*********************************
    
    
    
    
    
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
