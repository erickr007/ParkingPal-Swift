//
//  CoreDataManager.swift
//  ParkingPal
//
//  Created by Eric Robertson on 5/3/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class CoreDataManager{
    
    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer){
        persistentContainer = container
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    //MARK - ParkingSpace Methods
    //******************************
    
    func getActiveParkingSpace() -> ParkingSpace?{
        let context = persistentContainer.viewContext//(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var parkingSpace : ParkingSpace? = nil
        
        let request : NSFetchRequest<ParkingSpace> = ParkingSpace.fetchRequest()
        let predicate = NSPredicate(format: "isActive = true")
        
        request.predicate = predicate
        
        do{
            parkingSpace = try context.fetch(request).first
        }
        catch{
            print("Error retrieving Active Location: \(error)")
        }
        
        return parkingSpace
    }
    
    func startTrackingLocation(space: ParkingSpace){
        space.isActive = true
        space.timeIn = Date.init()
        
        saveContext()
    }
    
    func stopTrackingLocation(){
        let activeParkingSpace = getActiveParkingSpace()
        activeParkingSpace?.isActive = false
        activeParkingSpace?.timeOut = Date.init()
        saveContext()
    }
    
    
    //MARK - NotificationSettings
    //*********************************
    
    func getNotificationSettnings() -> NotificationSettings?{
        let context = persistentContainer.viewContext//((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        var notificationSettings: NotificationSettings? = nil
        let request : NSFetchRequest<NotificationSettings> = NotificationSettings.fetchRequest()
        
        do{
            notificationSettings = try context.fetch(request).first
            
            if notificationSettings == nil{
                initNotificationSettings()
            }
        }
        catch{
            print("Error retrieving NotificationSettings: \(error)")
        }
        
        return notificationSettings
    }
    
    
    func initNotificationSettings(){
        let context = persistentContainer.viewContext//((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        
        let notificationSettings: NotificationSettings = NotificationSettings(context: context)
        
        notificationSettings.isAllowed = true
        notificationSettings.isTimeElapsedRepeating = false
        notificationSettings.usePriorToExpiration = false
        notificationSettings.useTimeElapsed = false
        notificationSettings.useTimeExpired = true
        
        saveContext()
    }
    
    func getContext() -> NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    //MARK - Notifications
    //*************************
    
    func getLastNotificationSent(){
        let context = persistentContainer.viewContext//((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        
        
    }
    
    func addNotification(space: ParkingSpace, isTimeExpired: Bool){
        let context = persistentContainer.viewContext//((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        
        let notification = Notification(context: context)
        notification.dateCreated = Date()
        notification.forTimeExpired = isTimeExpired
        notification.forTimeElapsed = !isTimeExpired
        notification.notificationParkingSpace = space
        
        saveContext()
    }
    
    func saveContext(){
        let context = persistentContainer.viewContext
        do{
            try backgroundContext.save()
        }
        catch{
            print("Error saving context: \(error)")
        }
    }
    
}
