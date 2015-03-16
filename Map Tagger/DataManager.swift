//
//  DataManager.swift
//  Map Tagger
//
//  Created by Wiser Kuo on 2015/3/3.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import Foundation
let TopAppURL = "https://itunes.apple.com/us/rss/topgrossingipadapplications/limit=25/json"
let GMSURL = "https://maps.googleapis.com/maps/api/geocode/json?address="
class DataManager {
    
    class func getTopAppsDataFromFileWithSuccess(success: ((data: NSData) -> Void)) {
        //1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //2
            let filePath = NSBundle.mainBundle().pathForResource("TopApps",ofType:"json")
            
            var readError:NSError?
            if let data = NSData(contentsOfFile:filePath!,
                options: NSDataReadingOptions.DataReadingUncached,
                error:&readError) {
                    success(data: data)
            }
        })
    }
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    class func getTopAppsDataFromItunesWithSuccess(success: ((iTunesData: NSData!) -> Void)) {
        //1
        loadDataFromURL(NSURL(string: TopAppURL)!, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(iTunesData: urlData)
            }
        })
    }
    //class func getCoordinateFromGMS(address: String ) -> CLLocationCoordinate2D {
    class func getInfoFromGMS(address:String) -> Marker {
        var latitude: Double!
        var longtitude: Double!
        var formatted_address: String!
        var data: NSData!
        //1
        /*loadDataFromURL(NSURL(string: GMSURL+address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!, completion:{(data, error) -> Void in
            println("URL:\(GMSURL)\(address)")
            //2
            if let urlData = data {
              //3
              success(GMSData: urlData)
            }
            let json = JSON(data: data!)
            if let lat = json["results"][0]["geometry"]["location"]["lat"].double {
                print("in getCoordinate:\(lat),")
                latitude=lat
            }
            if let lng = json["results"][0]["geometry"]["location"]["lng"].double {
                println("\(lng)")
                longtitude=lng
            }
            println("latitude=\(latitude) , longtitude=\(longtitude)")
            
            
        })*/
        // Use NSURLSession to get data from an NSURL
       /* var session = NSURLSession.sharedSession()
        let loadDataTask = session.dataTaskWithURL(NSURL(string: GMSURL+address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
               // completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    //completion(data: nil, error: statusError)
                } else {
                   // completion(data: data, error: nil)
                }
            }
            
        })
        loadDataTask.resume()*/
        
        data = NSData(contentsOfURL: NSURL(string: GMSURL+address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        
        println("URL="+GMSURL+address.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        let json = JSON(data:data)
        if let lat = json["results"][0]["geometry"]["location"]["lat"].double {
            latitude=lat
        }
        if let lng = json["results"][0]["geometry"]["location"]["lng"].double {
            longtitude=lng
        }
        if let addr = json["results"][0]["formatted_address"].string{
            formatted_address=addr
        }
        println("latitude=\(latitude) , longtitude=\(longtitude)")
        println("address=\(formatted_address)")
        
        //return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude);
        return Marker(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), address: formatted_address)
        

       // return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude);
    }
}