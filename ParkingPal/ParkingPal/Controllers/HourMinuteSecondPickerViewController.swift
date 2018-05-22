//
//  HourMinuteSecondPickerViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 5/22/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import Foundation
import UIKit

protocol HourMinutePickerDelegate{
    func saveTimePicked(section: Int, hour: Int, minute: Int)
}

class HourMinuteSecondPickerViewController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var delegate: HourMinutePickerDelegate? = nil
    var pickerSection: Int = 1
    var selectedHours: Int = 0
    var selectedMinutes: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func dismiss(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        let workingValue = sender.countDownDuration / 3600
        selectedHours = Int(round(workingValue))
        
        var minutes = sender.countDownDuration - Double(selectedHours * 3600)
        minutes = minutes / 60
        
        selectedMinutes = Int(round(minutes))
        
    }
    
    @IBAction func saveTouched(_ sender: UIButton) {
        delegate?.saveTimePicked(section: pickerSection, hour: selectedHours, minute: selectedMinutes)
        dismiss()
    }
    @IBAction func dismissTouched(_ sender: UIButton) {
        dismiss()
    }
    


}
