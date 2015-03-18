//
//  ViewController.swift
//  Map Tagger
//
//  Created by Wiser Kuo on 2015/2/6.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import UIKit

class ViewController: UIViewController , CLLocationManagerDelegate ,GMSMapViewDelegate{
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressTextField: UITextField!
    var markerInfo:Marker!
    @IBAction func doneTableViewController(segue:UIStoryboardSegue){

    }
    @IBAction func locateTableViewController(segue:UIStoryboardSegue){
        let tableViewController = segue.sourceViewController as TableViewController
        let selectMarker = tableViewController.selectMarker
        println("locateTableViewController")

        mapView.camera = GMSCameraPosition(target: selectMarker.coordinate , zoom: 14, bearing: 0, viewingAngle: 0)
        mapView.clear()
        var marker = GMSMarker(position: selectMarker.coordinate)
        marker.title=selectMarker.address
        marker.snippet="\(selectMarker.coordinate.latitude),\(selectMarker.coordinate.longitude)"
        marker.map=self.mapView
        
        
    }
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        println("asdlhfkjadshk")
        markersData.append(markerInfo)

    }
    @IBAction func searchAddressTapped(sender: AnyObject) {
        println(addressTextField.text);

        
        /* DataManager.getCoordinateFromGMS(addressTextField.text) { (GMSData) -> CLLocationCoordinate2D in
            
           let json = JSON(data: GMSData)
            if let lat = json["results"][0]["geometry"]["location"]["lat"].double {
                print("\(lat),")
                latitude=lat
            }
            if let lng = json["results"][0]["geometry"]["location"]["lng"].double {
                println("\(lng)")
                longtitude=lng
            }
            
            println("inDATA:\(latitude),\(longtitude)")


        }*/
        
        //var coordinate:CLLocationCoordinate2D!
       // coordinate=DataManager.getCoordinateFromGMS(addressTextField.text)
        markerInfo=DataManager.getInfoFromGMS(addressTextField.text)
        //self.mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: 35.6894875 , longitude: 139.6917064 ) , zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.camera = GMSCameraPosition(target: markerInfo.coordinate , zoom: 14, bearing: 0, viewingAngle: 0)
        mapView.clear()
        var marker = GMSMarker(position: markerInfo.coordinate)
        marker.title=markerInfo.address
        marker.map=self.mapView
        marker.snippet="\(markerInfo.coordinate.latitude),\(markerInfo.coordinate.longitude)"
    
        //print("wiser:\(latitude)\(longtitude)")
        // mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: latitude , longitude: longtitude ) , zoom: 15, bearing: 0, viewingAngle: 0)
        // 6 CLLocationCoordinate2D

    }
    @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
        let segmentedControl = sender as UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeSatellite
        case 2:
            mapView.mapType = kGMSTypeHybrid
        default:
            mapView.mapType = mapView.mapType
        }
    }
    let locationManager = CLLocationManager()
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        if status == .AuthorizedWhenInUse {
            
            // 3
            locationManager.startUpdatingLocation()
            
            //4
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // 5
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            // 6 CLLocationCoordinate2D
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 7
            locationManager.stopUpdatingLocation()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate=self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

}

