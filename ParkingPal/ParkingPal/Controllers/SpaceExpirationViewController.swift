//
//  SpaceExpirationViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 4/26/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

protocol SpaceExpirationDelgate{
    func updateExpiration(date: Date)
    func clearExpireDate()
}

class SpaceExpirationViewController: UIViewController, UIPickerViewDelegate {
    
    var delegate: SpaceExpirationDelgate? = nil
    var selectedExpireDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func expireDateChanged(_ sender: UIDatePicker) {
        selectedExpireDate = sender.date
    }
    
    @IBAction func saveTouched(_ sender: Any) {
        delegate?.updateExpiration(date: selectedExpireDate!)
        dismissViewController()
    }
    
    @IBAction func clearTouched(_ sender: UIButton) {
        delegate?.clearExpireDate()
       dismissViewController()
    }
    
    func dismissViewController(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

}
