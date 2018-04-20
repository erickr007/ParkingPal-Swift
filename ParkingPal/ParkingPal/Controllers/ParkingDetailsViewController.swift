//
//  ParkingDetailsViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 3/27/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import SVProgressHUD
import UIKit

class ParkingDetailsViewController: UIViewController, ParkingDetailsTableDelegate {

    var currentLocation: Location? = nil
    
    //IBOutlets
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var detailsContainer: UIView!
    @IBOutlet var mainView: UIView!
    
    //constants
    
    //variable properties
    private var detailsTableVC: ParkingDetailsTableTableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //- hide control and display progresshud
        
        SVProgressHUD.show()
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadLocationUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedLocationDetails"{
            detailsTableVC = segue.destination as? ParkingDetailsTableTableViewController
            detailsTableVC?.delegate = self
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: UI Setup functions
    func loadLocationUI(){
        if let location = currentLocation{
            locationTitle.text = location.title
            detailsTableVC?.address.text = currentLocation?.address
            detailsTableVC?.parkingDescription.text = currentLocation?.detailSummary
            detailsTableVC?.parkingType.text = ParkingType(rawValue: (currentLocation?.parkingType)!)?.description()
            
        }
        
        SVProgressHUD.dismiss()
        mainView.isHidden = false
    }
    
    //MARK: ParkingDetailsTableDelegate functions
    func goToDetails() {
        performSegue(withIdentifier: "goToDetailsSetLocation", sender: self)
    }

}
