//
//  IdentifyViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 3/28/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

protocol IdentifyViewDelegate{
    func setLocation()
    func closeIdentify()
    func goToLocation()
}

class IdentifyViewController: UIViewController {

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    public var delegate: IdentifyViewDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        delegate?.setLocation()
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
