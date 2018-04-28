//
//  SpaceFloorViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/23/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

protocol SpaceFloorDelegate{
    func spaceFloorUpdated(floor: String)
    func clearSpaceFloor()
}

class SpaceFloorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var floorNumberPicker: UIPickerView!
    
    var delegate: SpaceFloorDelegate? = nil
    var floorNumbers: [String] = [String]()
    
    var selectedFloor: String = "L"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floorNumberPicker.delegate = self
        floorNumberPicker.dataSource = self
        loadFloorNumbers()
    }

    
    func loadFloorNumbers(){
        floorNumbers.append("PP")
        floorNumbers.append("P1")
        floorNumbers.append("P2")
        floorNumbers.append("P3")
        floorNumbers.append("P4")
        floorNumbers.append("L")
        floorNumbers.append("LL")
        for index in 0 ... 10 {
            floorNumbers.append(String(index))
        }
    }

    @IBAction func saveFloorTouched(_ sender: Any) {
        delegate?.spaceFloorUpdated(floor: selectedFloor)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearSelectedFloor(_ sender: UIButton) {
        delegate?.clearSpaceFloor()
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    //MARK:  UIPickerViewDataSource Methods
    //*****************************************
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return floorNumbers.count
    }
    

    //MARK: UIPickerViewDelegate Methods
    //***************************************
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return floorNumbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFloor = floorNumbers[row]
    }

}
