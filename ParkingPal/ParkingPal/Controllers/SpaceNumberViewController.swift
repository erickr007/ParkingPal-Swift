//
//  SpaceInfoViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/13/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

protocol SpaceNumberDelegate{
    func spaceNameUpdated(space: String)
    func spaceSuffixUpdated(suffixList: [String])
    func clearSpaceName()
}

class SpaceNumberViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, AddSuffixDelegate, SuffixTableViewDelegate {
    

    @IBOutlet weak var spaceNumberPicker: UIPickerView!
    @IBOutlet weak var addSuffixButton: UIButton!
    
    var suffixTableVC: SuffixTableViewController? = nil
    var delegate: SpaceNumberDelegate? = nil
    var spaceNumbers: [String] = [String]()
    var suffixList: [String] = [String]()
    var selectedSpaceNumber: String? = "0"
    var isEdit: Bool = false
    
    func set(spaceNumber: String, suffixes: [String]?){
        selectedSpaceNumber = spaceNumber
        
        if let list = suffixes{
            suffixList = list
        }
        
        isEdit = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        spaceNumberPicker.dataSource = self
        spaceNumberPicker.delegate = self
        
        loadSpaces()
        
        if isEdit{
            spaceNumberPicker.selectRow(Int(selectedSpaceNumber!)!, inComponent: 0, animated: true)
        }
    }

    func loadSpaces(){
        for index in 0 ... 500 {
            spaceNumbers.append(String(index))
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddSuffix"{
            let addSuffixVC = segue.destination as! AddSuffixViewController
            addSuffixVC.delegate = self
        }
        else if segue.identifier == "embedSuffixTable"{
            suffixTableVC = segue.destination as! SuffixTableViewController
            suffixTableVC?.delegate = self
            suffixTableVC?.suffixList = suffixList
        }
    }
    
    @IBAction func saveSpaceInfoTouched(_ sender: UIButton) {
    
        delegate?.spaceNameUpdated(space: selectedSpaceNumber!)
        delegate?.spaceSuffixUpdated(suffixList: suffixList)
        
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearSpaceTouched(_ sender: UIButton) {
        delegate?.clearSpaceName()
        
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:  SuffixTableViewDelegate
    //*********************************
    
    
    func updateSuffixList(list: [String]) {
        suffixList = list
        delegate?.spaceSuffixUpdated(suffixList: list)
    }
    
    
    //MARK: AddSuffixDelegate Methods
    //**************************
    
    func addSuffix(suffix: String) {
        suffixList.append(suffix)
        
        //- disable Add Suffix button when list reaches 5
        if suffixList.count == 5 {
            addSuffixButton.isEnabled = false
        }
        
        suffixTableVC?.suffixList = suffixList
        suffixTableVC?.tableView.reloadData()
    }
    
    
    //MARK: UIPickerViewDataSource
    //********************************
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return spaceNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return spaceNumbers[row]
    }
    
    
    //MARK: UPickerViewDelegate
    //*****************************
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSpaceNumber = String(row)
    }
    

}
