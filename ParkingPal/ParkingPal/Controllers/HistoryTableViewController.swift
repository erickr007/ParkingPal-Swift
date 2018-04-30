//
//  MyLocationsViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 3/28/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import CoreData
import UIKit

class HistoryTableViewController: SwipeableTableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var parkingSpaceList: [ParkingSpace] = [ParkingSpace]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 60
        
        loadItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    func loadItems(){
        let request : NSFetchRequest<ParkingSpace> = ParkingSpace.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timeIn", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        do{
            parkingSpaceList = try context.fetch(request)
        }
        catch{
            print("Error while fetching ParkingSpace history: \(error)")
        }
        
    }
    
    func saveContext(){
        do{
            try context.save()
        }
        catch{
            print("Error saving content from HistoryTableViewController: \(error)")
        }
    }
    
    //MARK: TableViewDataSource Methods
    //*************************************
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingSpaceList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryTableViewCell = super.tableView(tableView, cellForRowAt: indexPath) as! HistoryTableViewCell
        let space = parkingSpaceList[indexPath.row]
        
        cell.titleLabel.text = space.spaceLocation?.title
        cell.addressLabel.text = space.spaceLocation?.address
        
        if space.isActive{
            cell.backgroundColor = UIColor(displayP3Red: 0, green: 1.0, blue: 0, alpha: 0.7)
        }
        else{
            cell.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        return cell
    }
    
    
    //MARK: TableViewDelegate Methods
    //***************************************
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    //MARK:  SwipeCellTableViewController Methods
    //**********************************************
    override func deleteRow(indexPath: IndexPath) {
        context.delete(parkingSpaceList[indexPath.row])
        parkingSpaceList.remove(at: indexPath.row)
        
        saveContext()
    }
    
    
    //MARK: UI Actions
    //********************
    
    @IBAction func doneTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
