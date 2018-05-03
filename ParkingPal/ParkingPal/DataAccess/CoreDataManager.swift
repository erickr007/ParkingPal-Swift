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
    
    static func getActiveParkingSpace() -> ParkingSpace?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
    
    static func startTrackingLocation(space: ParkingSpace){
        space.isActive = true
        space.timeIn = Date.init()
        
        saveContext()
    }
    
    static func stopTrackingLocation(){
        let activeParkingSpace = getActiveParkingSpace()
        activeParkingSpace?.isActive = false
        activeParkingSpace?.timeOut = Date.init()
        saveContext()
    }
    
    static func saveContext(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try context.save()
        }
        catch{
            print("Error saving context: \(error)")
        }
    }
}
