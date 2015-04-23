//
//  GooglePlace.swift
//  SearchController
//
//  Created by wiserkuo on 2015/4/22.
//  Copyright (c) 2015年 wiserkuo. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
/*
class GooglePlace {
    
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let placeType: String
    let photoReference: String?
    var photo: UIImage?
    
    init(dictionary:NSDictionary, acceptedTypes: [String])
    {
        name = dictionary["name"] as! String
        address = dictionary["vicinity"] as! String
        
        let location = dictionary["geometry"]?["location"] as! NSDictionary
        let lat = location["lat"] as! CLLocationDegrees
        let lng = location["lng"] as! CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        if let photos = dictionary["photos"] as? NSArray {
            let photo = photos.firstObject as! NSDictionary
            photoReference = (photo["photo_reference"] as! String)
        }
        else {
            photoReference = nil
        }
        var foundType = "restaurant"
        let possibleTypes = acceptedTypes.count > 0 ? acceptedTypes : ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
        for type in dictionary["types"] as! [String] {
            if contains(possibleTypes, type) {
                foundType = type
                break
            }
        }
        placeType = foundType
    }
}
*/
class Prediction {
    let description : String
    let place_id : String
    //var types = [String]()
    init(dictionary:NSDictionary){
        description = dictionary["description"] as! String
        place_id = dictionary["place_id"] as! String
    }
}
class Detail {
    let address :String
    let coordinate:CLLocationCoordinate2D
    init(dictionary:NSDictionary){
       
        address  = dictionary["formatted_address"] as! String
        //coordinat
        let location = dictionary["geometry"]?["location"] as! NSDictionary
        let lat = location["lat"] as! CLLocationDegrees
        let lng = location["lng"] as! CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        println("Detail: address \(address)")
    }
}