//
//  Marker.swift
//  Map Tagger
//
//  Created by wiserkuo on 2015/3/11.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import Foundation
import UIKit
class Marker: NSObject {
    var coordinate: CLLocationCoordinate2D
    var address: String
    init(coordinate : CLLocationCoordinate2D,address : String){
        self.coordinate = coordinate
        self.address = address
        super.init()
    }
}