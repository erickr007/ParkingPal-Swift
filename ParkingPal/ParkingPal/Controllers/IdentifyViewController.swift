//
//  IdentifyViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 3/28/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

protocol BaseLocationTrackingProtocol{
    func setLocation()
    func startTrackingLocation(space: ParkingSpace)
    func stopTrackingLocation()
}

protocol IdentifyViewDelegate: BaseLocationTrackingProtocol{
    func closeIdentify()
    func goToLocation()
}

class IdentifyViewController: UIViewController {

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var setLocationButton: UIButton!
    
    var delegate: IdentifyViewDelegate? = nil
    var isActiveLocationSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Actions

    @IBAction func closeButton(_ sender: UIButton) {
        delegate?.closeIdentify()
    }
    
    @IBAction func detailsButton(_ sender: Any) {
        delegate?.goToLocation()
    }
    
    @IBAction func setLocationButton(_ sender: Any) {
        
        if isActiveLocationSet == false{
            delegate?.setLocation()
        }
        else{
            CoreDataManager.stopTrackingLocation()
            delegate?.stopTrackingLocation()
        }
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
