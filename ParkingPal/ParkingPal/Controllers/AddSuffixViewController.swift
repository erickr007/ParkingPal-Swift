//
//  AddSuffixViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/14/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

protocol AddSuffixDelegate{
    func addSuffix(suffix: String)
}

class AddSuffixViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var segmentTabControl: UISegmentedControl!
    @IBOutlet weak var pickerCharacters: UIPickerView!
    @IBOutlet weak var pickerColors: UIPickerView!
    
    var delegate: AddSuffixDelegate? = nil
    var selectedSuffix: String? = nil
    
    var characterList: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var colorList: [String] = ["Black","Blue","Brown","Gray","Green","Orange","Purple","Red","White","Yellow"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerCharacters.dataSource = self
        pickerCharacters.delegate = self
        pickerColors.dataSource = self
        pickerColors.delegate = self
        
        segmentTabControl.selectedSegmentIndex = 0
        displaySelectedPicker()
    }
    
    func displaySelectedPicker(){
        if segmentTabControl.selectedSegmentIndex == 0{
            pickerCharacters.isHidden = false
            pickerColors.isHidden = true
        }
        else{
            pickerCharacters.isHidden = true
            pickerColors.isHidden = false
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        displaySelectedPicker()
    }
    
    @IBAction func saveTouched(_ sender: UIButton) {
        
        if let suffix = selectedSuffix{
            delegate?.addSuffix(suffix: suffix)
            dismiss(animated: true, completion: nil)
        }
        else{
            let errorAlertController = UIAlertController(title: "Add Suffix Error", message: "You must select a suffix", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default){
                (action) in
                
            }
            
            errorAlertController.addAction(okAction)
            present(errorAlertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: UIPickerDataSource Methods
    //************************************
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return characterList.count
        }
        else{
            return colorList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return characterList[row]
        }
        else{
            return colorList[row]
        }
    }
    
    
    //MARK:  UIPickerDelegate Methods
    //**************************************
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            selectedSuffix = characterList[row]
        }
        else{
            selectedSuffix = colorList[row]
        }
    }
}
