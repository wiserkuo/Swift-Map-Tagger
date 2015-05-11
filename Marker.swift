//
//  Map_Tagger.swift
//  Map Tagger
//
//  Created by Wiser Kuo on 2015/4/2.
//  Copyright (c) 2015年 sw5. All rights reserved.
//
import Foundation
import CoreData

class Marker: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var latitude: Double
    @NSManaged var longtitude: Double
    @NSManaged var address: String
    @NSManaged var note: String
    @NSManaged var date: String
    @NSManaged var photo: NSData
    @NSManaged var hasPhoto: Boolean
}
class MarkerModel: NSObject {
    var name:String
    var coordinate:CLLocationCoordinate2D
    var address:String
    var note: String
    var date: String
    var photo: UIImage
    var hasPhoto: Bool
    init(name:String , coordinate:CLLocationCoordinate2D , address:String){
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.note = ""
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.stringFromDate(NSDate())
        self.hasPhoto = false
        self.photo = UIImage(named: "default")!
        super.init()
    }
}