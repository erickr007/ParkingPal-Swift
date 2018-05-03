//
//  BrowseLocationsTableViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 5/2/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import UIKit

class BrowseLocationsTableViewController: UITableViewController, BaseLocationTrackingProtocol {
    
    var delegate: BaseLocationTrackingProtocol? = nil

    var locations: [Location] = []
    var selectedIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Back"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "browseCell", for: indexPath) as! BrowseLocationTableViewCell

        cell.titleLabel.text = locations[indexPath.row].title
        cell.addressLabel.text = locations[indexPath.row].address

        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        performSegue(withIdentifier: "goFromBrowseToDetails", sender: self)
    }

    // MARK: - BaseLocationTrackingProtocol Methods
    //******************************************
    
    
    func setLocation() {
        delegate?.setLocation()
    }
    
    func startTrackingLocation(space: ParkingSpace) {
        delegate?.startTrackingLocation(space: space)
    }
    
    func stopTrackingLocation() {
        delegate?.stopTrackingLocation()
    }
    
    
    // MARK: - Navigation
    //******************************************

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFromBrowseToDetails"{
            let detailsVC = segue.destination as! ParkingDetailsViewController
            
            if let index = selectedIndex {
                detailsVC.currentLocation = locations[index]
                detailsVC.delegate = self
            }
        }
    }
 

}
