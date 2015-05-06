//
//  GooglePlaceAPI.swift
//  SearchController
//
//  Created by wiserkuo on 2015/4/22.
//  Copyright (c) 2015年 wiserkuo. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation



class GooglePlaceAPI {
    let apiKey = "AIzaSyA0LhU68y48rb04f4kfvMH8xOsyCr7xz24"
    var placesTask = NSURLSessionDataTask()
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    var predictions = [Prediction]()
    //var detail : Detail!
//https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyA0LhU68y48rb04f4kfvMH8xOsyCr7xz24&input=new%20york
    func fetchPlacesAutoComplete(input:String, completion: (([Prediction]) -> Void)) -> Void
    {
        
      
       //var downloadGroup = dispatch_group_create()
       self.predictions.removeAll()
       var urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(self.apiKey)&input=\(input)"
       // println("\(urlString1)")
        //let typesString = types.count > 0 ? join("|", types) : "food"
        //urlString += "&types=\(typesString)"
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if self.placesTask.taskIdentifier > 0 && self.placesTask.state == .Running {
            self.placesTask.cancel()
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
       // dispatch_group_enter(downloadGroup)
        self.placesTask = self.session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.predictions = [Prediction]()
            if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? NSDictionary {
                if let results = json["predictions"] as? NSArray {
                    for rawPlace:AnyObject in results {
                        let place = Prediction(dictionary: rawPlace as! NSDictionary)
                        self.predictions.append(place)
                      //  println("\(place.description) , \(place.place_id)")
                    }
                }
            }
           // dispatch_group_leave(downloadGroup)
           // dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER)
            if let gotSearchController: AnyClass = NSClassFromString("UISearchController"){
                dispatch_async(dispatch_get_main_queue()) {
                    completion(self.predictions)
                }
            }
            else{
                completion(self.predictions)
            }
        }
        
        self.placesTask.resume()

    }
    func fetchPlacesDetail(placeid:String, completion: ((Detail?) -> Void)) -> ()
    {
        var place : Detail!
        var urlString = "https://maps.googleapis.com/maps/api/place/details/json?key=\(apiKey)&placeid=\(placeid)"
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if placesTask.taskIdentifier > 0 && placesTask.state == .Running {
            placesTask.cancel()
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? NSDictionary {
                if let results = json["result"] as? NSDictionary {
                    place = Detail(dictionary: results)
                    println("\(place.address) , \(place.coordinate.latitude) , \(place.coordinate.longitude)")
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(place)
            }
        }
        placesTask.resume()
    }


}