//
//  RestManager.swift
//  ParkingPal
//
//  Created by Eric Robertson on 3/20/18.
//  Copyright © 2018 Eric Robertson. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

class RestManager{
    static let parkingPalAPIUrl = "https://parkingpalapi.azurewebsites.net/"
    
    static func getAllParkingLocations() -> [Location]{
        var locations: [Location] = []
        
        Alamofire.request(parkingPalAPIUrl + "locations", method: .get, parameters: nil).responseJSON {
            (response) in
            if response.result.isSuccess{
                let locationArray = JSON(response.result.value!).array!
                locationArray.forEach {
                    (json: JSON) in
                    
                    locations.append(RestManager.parkingLocation(from: json))
                }
            }
            else{
                print("Error requesting locations \(response.error!)")
            }
        }
        
        return locations
    }
    
    static func parkingLocation(from json: JSON) -> Location{
        let location: Location = Location()
        
        location.address = json["ad"].string
        location.latitude = json["lt"].double!
        location.longitude = json["lg"].double!
        location.parkingType = json["pt"].int32!
        location.detailSummary = json["ds"].string
        location.title = json["tt"].string
        location.website = json["ws"].string
        
        return location
    }
}
