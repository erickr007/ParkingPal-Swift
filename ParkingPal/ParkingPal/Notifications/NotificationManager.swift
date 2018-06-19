//
//  NotificationManager.swift
//  ParkingPal
//
//  Created by Eric Robertson on 5/28/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationManagerDelegate{
    func updateParkingSpaceState(isExpired: Bool, space: ParkingSpace?)
}

class NoticationManager{
    
    var notificationSettings: NotificationSettings?
    var currentParkingSpace: ParkingSpace?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    public var isCurrentNotificationExpired: Bool = false
    
    init (){
        notificationSettings = CoreDataManager.getNotificationSettnings()
        currentParkingSpace = CoreDataManager.getActiveParkingSpace()
        
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
    
    func isParkingSpaceUsingExpiration() -> Bool{
        if currentParkingSpace == nil {
            return false
        }
        
        if currentParkingSpace?.expireTime == nil{
            return false
        }
        
        return true
    }
    
    func checkIfNotificationExpired(){
        if !isParkingSpaceUsingExpiration() {
            return
        }
        
        if let settings = notificationSettings{
            
            if settings.isAllowed && settings.useTimeExpired{
                
                if let expireTime = currentParkingSpace?.expireTime{
                    let space = currentParkingSpace!
                    
                    if Date() >= expireTime{
                        //get previously sent time expired notifications
                        let notifications = space.spaceNotifications?.filter({ (notif) -> Bool in
                            return (notif as! Notification).forTimeExpired
                        })
                        
                        //send expire notification if none previously sent
                        if notifications == nil || notifications?.count == 0{
                            //SEND NOTIFICATION HERE
                            CoreDataManager.addNotification(space: space, isTimeExpired: true)
                        }
                        else{
                            
                            let notifArray = notifications as! [Notification]
                            let lastNotificationTime = (notifArray[0].dateCreated?.timeIntervalSince1970)!
                            
                            //send new notification if existing notification(s) occurred prior to expiration
                            //previously sent about to expire notification sent
                            if(lastNotificationTime < expireTime.timeIntervalSince1970){
                                //SEND NOTIFICATION HERE
                                CoreDataManager.addNotification(space: space, isTimeExpired: true)
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func checkIfNotificationAboutToExpire(){
        if let expireTime = currentParkingSpace?.expireTime, let notifSettings = notificationSettings{
            let space = currentParkingSpace!
            
            //nothing to send if expired date has already passed
            if expireTime <= Date(){
                return
            }
            
            //get previously sent time expired notifications
            let notifications = space.spaceNotifications?.filter({ (notif) -> Bool in
                return (notif as! Notification).forTimeExpired
            })
            
            if notifications == nil || notifications?.count == 0{
                let expireBuffer = TimeInterval(notifSettings.timePriorToExpiration) * -1
                let expireThreshold = expireTime.addingTimeInterval(TimeInterval(expireBuffer))
                
                if(Date() >= expireThreshold){
                    //SEND NOTIFICATION HERE
                    CoreDataManager.addNotification(space: space, isTimeExpired: true)
                }
            }
        }
    }
    
    func checkIfTimeElapsed(){
        if let expireTime = currentParkingSpace?.expireTime{
            let space = currentParkingSpace!
            
            //do not send TimeElapsed notification on expired space
            if expireTime <= Date(){
                return
            }
            
        if let settings = notificationSettings{
            if settings.useTimeElapsed{
                
                if let timeIn = space.timeIn{
                    let elapseTime = timeIn.timeIntervalSince1970 + TimeInterval(settings.timeElapsed * 60)//addingTimeInterval(TimeInterval(settings.timeElapsed))
                    
                    //get previously sent time elapsed notifications
                    let notifications = space.spaceNotifications?.filter({ (notif) -> Bool in
                        return (notif as! Notification).forTimeElapsed
                    })
                    
                    //if time specified has elapsed and no prior notification was sent
                    if elapseTime > Date().timeIntervalSince1970 && (notifications == nil || notifications?.count == 0){
                        
                            //SEND NEW ELAPSED NOTIFICATION
                            CoreDataManager.addNotification(space: space, isTimeExpired: false)
                        
                    }
                    else if let isContinuous = notificationSettings?.isTimeElapsedRepeating {
                        var notifs: [Notification] = notifications as! [Notification]
                        notifs.reverse()
                        
                        //get the time elapsed since last notification was sent
                        //if greater than the elapsed time threshold
                        let lastNotif = notifs[0].dateCreated?.timeIntervalSinceNow
                        let elapsedThreshold = (notificationSettings?.timeElapsed)! * 60
                        
                        if isContinuous && lastNotif! >= TimeInterval(elapsedThreshold){
                            
                            //SEND NOTIFICATION
                            CoreDataManager.addNotification(space: space, isTimeExpired: false)
                            
                        }
                        
                    }
                }
                
            }
        }
        }
    }
    
    func startNotifications(){
        
    }
    
    func stopNotifications(){
        
    }
    
}
