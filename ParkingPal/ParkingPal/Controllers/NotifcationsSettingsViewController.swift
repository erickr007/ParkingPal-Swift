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
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var timePriorToExpirationLabel: UILabel!
    
    var coreDataManager: CoreDataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coreDataManager = CoreDataManager(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer)
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
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        
        if(indexPath.row < 2){
            return 44
        }
        else{
            return 0
        }
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        else if(section == 1){
            return 3
        }
        else{
            return 1
        }
    }
    
    func loadNotificationSettings(){
        notificationSettings = coreDataManager?.getNotificationSettnings()
        
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
        
        if let timeElapsed = notificationSettings?.timeElapsed {
            timeElapsedLabel.text = String(timeElapsed)
        }
        
        if let timePriorToExpiration = notificationSettings?.timePriorToExpiration{
            timePriorToExpirationLabel.text = String(timePriorToExpiration)
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
        
        saveContext()
    }
    

    // MARK: - Table view data source
    //************************************

    override func numberOfSections(in tableView: UITableView) -> Int {
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
        if(section == 1){
            notificationSettings?.timeElapsed = Int32((minute * 60) + (hour * 3600))
        }
        else if(section == 2){
            notificationSettings?.timePriorToExpiration = Int32((minute * 60) + (hour * 3600))
        }
        
        //let time = notificationSettings?.timePriorToExpiration
        
        saveContext()
        loadNotificationSettings()
    }
    
    func saveContext(){
        coreDataManager?.saveContext()
    }
    
}
