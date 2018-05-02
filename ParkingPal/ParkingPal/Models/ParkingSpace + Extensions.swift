//
//  ParkingSpace + Metadata.swift
//  ParkingPal
//
//  Created by Eric Robertson on 5/2/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import Foundation


extension ParkingSpace{
    func fullyQualifiedName() -> String{
        var fullName: String = spaceLocation?.title ?? ""
        
        if let spaceName = name{
            fullName += " Space: " + spaceName
        }
        else{
            fullName += " Space: N/A"
        }
        
        if let spaceFloor = floor{
            fullName += " Floor: " + spaceFloor
        }
        
        return fullName
    }
}
