//
//  NotifcationsSettingsViewController.swift
//  ParkingPal
//
//  Created by Eric Robertson on 5/15/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import CoreData
import UIKit

class NotifcationsSettingsViewController: UITableViewController, HourMinutePickerDelegate {

    var notificationSettings: NotificationSettings? = nil
    
    @IBOutlet weak var allowNotificationsSwitch: UISwitch!
    @IBOutlet weak var useTimeElapsedSwitch: UISwitch!
    @IBOutlet weak var continuosTimeElapsedSwitch: UISwitch!
    @IBOutlet weak var useExpiredTimeSwitch: UISwitch!
    @IBOutlet weak var useAboutToExpireSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNotificationSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTimePicker" {
            let hourMinTimePickerVC = segue.destination as! HourMinuteSecondPickerViewController
            hourMinTimePickerVC.delegate = self
            if let section = tableView.indexPathForSelectedRow?.section {
                hourMinTimePickerVC.pickerSection = section
            }
        }
    }
    
    func loadNotificationSettings(){
        notificationSettings = CoreDataManager.getNotificationSettnings()
        
        
        if let isAllowed = notificationSettings?.isAllowed {
            allowNotificationsSwitch.isOn = isAllowed
        }
        
        // Time Elapsed
        
        if let useTimeElapsed = notificationSettings?.useTimeElapsed{
            useTimeElapsedSwitch.isOn = useTimeElapsed
        }
        
        if let useContinuousTime = notificationSettings?.isTimeElapsedRepeating{
            continuosTimeElapsedSwitch.isOn = useContinuousTime
        }
        
        
        // Time Expired
        
        if let useTimeExpired = notificationSettings?.useTimeExpired{
            useExpiredTimeSwitch.isOn = useTimeExpired
        }
        
        if let useAboutToExpire = notificationSettings?.usePriorToExpiration{
            useAboutToExpireSwitch.isOn = useAboutToExpire
        }
    }
    
    
    func disableAllSwitchControls(){
        useTimeElapsedSwitch.isEnabled = false
        continuosTimeElapsedSwitch.isEnabled = false
        useExpiredTimeSwitch.isEnabled = false
        useAboutToExpireSwitch.isEnabled = false
    }
    
    
    //MARK - UI Action Handlers
    //*********************************
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        let tag = sender.tag
        
        if tag == 0{
            notificationSettings?.isAllowed = allowNotificationsSwitch.isOn
        }
        else if tag == 1{
            notificationSettings?.useTimeElapsed = useTimeElapsedSwitch.isOn
        }
        else if tag == 2{
            notificationSettings?.isTimeElapsedRepeating = continuosTimeElapsedSwitch.isOn
        }
        else if tag == 3{
            notificationSettings?.useTimeExpired = useExpiredTimeSwitch.isOn
        }
        else if tag == 4{
            notificationSettings?.usePriorToExpiration = useAboutToExpireSwitch.isOn
        }
        
        CoreDataManager.saveContext()
    }
    

    // MARK: - Table view data source
    //************************************

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    // MARK: - Table view delegate
    //********************************
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToTimePicker", sender: self)
    }
    

    // MARK: - HourMinutePickerDelegate
    //*************************************
    
    func saveTimePicked(section: Int, hour: Int, minute: Int) {
        print("section: \(section), hour: \(hour), minute: \(minute)")
    }
    
}
