//
//  NotificationManager.swift
//  ParkingPal
//
//  Created by Eric Robertson on 5/28/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol NotificationManagerDelegate{
    func updateParkingSpaceState(isExpired: Bool, space: ParkingSpace?)
}

class NotificationManager{
    
    var notificationSettings: NotificationSettings?
    var currentParkingSpace: ParkingSpace?
    
    let coreDataManager: CoreDataManager
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var managerTimer: Timer?
    
    public var isCurrentNotificationExpired: Bool = false
    
    init (container: NSPersistentContainer){
        coreDataManager = CoreDataManager.init(container: container)
        notificationSettings = coreDataManager.getNotificationSettnings()
        currentParkingSpace = coreDataManager.getActiveParkingSpace()
        
        /*
         NotificationManager checklist:
         1.  obtain notification settings;  if set to receive alerts then...
         2.  obtain active location;  if one exists then...
         3.  obtain last notification sent...
         4.  determine if: new notification should be sent; notify bar state should change
         
         Running in the Foreground:
         1.  use timer to check status every 2min
         
         Running in the Background:
         1.  if enabled use BackgroundApp Refresh to check when location changes
         */
    }
    
    @objc func runNotifications(){
        checkIfNotificationExpired()
        checkIfNotificationAboutToExpire()
        checkIfTimeElapsed()
    }
    
    func isParkingSpaceUsingExpiration() -> Bool{
        if currentParkingSpace == nil {
            return false
        }
        
        if currentParkingSpace?.expireTime == nil{
            return false
        }
        
        return true
    }
    
    func checkIfNotificationExpired() -> Bool{
        if !isParkingSpaceUsingExpiration() {
            return false
        }
        
        if let settings = notificationSettings, let expireTime = currentParkingSpace?.expireTime, let space = currentParkingSpace{
            
            if settings.isAllowed && settings.useTimeExpired{
                    
                    if Date() >= expireTime{
                        //get previously sent time expired notifications
                        let notifications = space.spaceNotifications?.filter({ (notif) -> Bool in
                            return (notif as! Notification).forTimeExpired
                        })
                        
                        //send expire notification if none previously sent
                        if notifications == nil || notifications?.count == 0{
                            //SEND NOTIFICATION HERE
                            coreDataManager.addNotification(space: space, isTimeExpired: true)
                            return true
                        }
                        else{
                            
                            let notifArray = notifications as! [Notification]
                            let lastNotificationTime = (notifArray[0].dateCreated?.timeIntervalSince1970)!
                            
                            //send new notification if existing notification(s) occurred prior to expiration
                            //previously sent about to expire notification sent
                            if(lastNotificationTime < expireTime.timeIntervalSince1970){
                                //SEND NOTIFICATION HERE
                                coreDataManager.addNotification(space: space, isTimeExpired: true)
                                return true
                            }
                        }
                        
                    }
                  
            }
        }
        
        return false
    }
    
    func checkIfNotificationAboutToExpire() -> Bool{
        if let expireTime = currentParkingSpace?.expireTime, let settings = notificationSettings, let space = currentParkingSpace{
            
            if settings.isAllowed == false{
                return false
            }
            
            //nothing to send if expired date has already passed
            if expireTime <= Date(){
                return false
            }
            
            //get previously sent time expired notifications
            let notifications = space.spaceNotifications?.filter({ (notif) -> Bool in
                return (notif as! Notification).forTimeExpired
            })
            
            if notifications == nil || notifications?.count == 0{
                let expireBuffer = TimeInterval(settings.timePriorToExpiration * 60) * -1
                let expireThreshold = expireTime.addingTimeInterval(TimeInterval(expireBuffer))
                
                if(Date() >= expireThreshold){
                    //SEND NOTIFICATION HERE
                    coreDataManager.addNotification(space: space, isTimeExpired: true)
                    return true
                }
            }
        }
        
        return false
    }
    
    func checkIfTimeElapsed() -> Bool{
        guard let exTime = currentParkingSpace?.expireTime else {
            return false
        }
        guard let sett = notificationSettings else{
            return false
        }
        if let expireTime = currentParkingSpace?.expireTime, let settings = notificationSettings,let space = currentParkingSpace, let timeIn = space.timeIn, let isContinuous = notificationSettings?.isTimeElapsedRepeating{
            
            if settings.isAllowed == false{
                return false
            }
            
            //do not send TimeElapsed notification on expired space
            if expireTime <= Date(){
                return false
            }
            
            if settings.useTimeElapsed{
                
                    let elapseTime = timeIn.timeIntervalSince1970 + TimeInterval(settings.timeElapsed * 60)//addingTimeInterval(TimeInterval(settings.timeElapsed))
                    
                    //get previously sent time elapsed notifications
                    let notifications = space.spaceNotifications?.filter({ (notif) -> Bool in
                        return (notif as! Notification).forTimeElapsed
                    })
                    
                    //if time specified has elapsed and no prior notification was sent
                    if elapseTime > Date().timeIntervalSince1970 && (notifications == nil || notifications?.count == 0){
                        
                            //SEND NEW ELAPSED NOTIFICATION
                            coreDataManager.addNotification(space: space, isTimeExpired: false)
                        return true
                    }
                    else {
                        var notifs: [Notification] = notifications as! [Notification]
                        notifs.reverse()
                        
                        //get the time elapsed since last notification was sent
                        //if greater than the elapsed time threshold
                        let lastNotif = notifs[0].dateCreated?.timeIntervalSinceNow
                        let elapsedThreshold = (notificationSettings?.timeElapsed)! * 60
                        
                        if isContinuous && lastNotif! >= TimeInterval(elapsedThreshold){
                            
                            //SEND NOTIFICATION
                            coreDataManager.addNotification(space: space, isTimeExpired: false)
                            return true
                        }
                        
                    }
                
                
            }
        }
            return false
    }
    
    func startNotifications(){
        managerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runNotifications), userInfo: nil, repeats: true)
        
    }
    
    func stopNotifications(){
        managerTimer?.invalidate()
    }
    
}
