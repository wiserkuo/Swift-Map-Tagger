//
//  ViewController.swift
//  Map Tagger
//
//  Created by Wiser Kuo on 2015/2/6.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import UIKit
import CoreData
var searcher : UISearchController!
var searcher2 : UISearchDisplayController!

class ViewController: UIViewController , CLLocationManagerDelegate ,GMSMapViewDelegate , UISearchBarDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressTextField: UITextField!
    var markerInfo:MarkerModel!
    let googlePlaceAPI = GooglePlaceAPI()
    let src = AutoCompleteController()
    var src2 = SearchTableViewController()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as!AppDelegate).managedObjectContext
    var autoCompleteName :String!
    var autoCompletePlaceID : String!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBarView: UIView!
    
    
    
    @IBAction func searchTapped(sender: AnyObject) {
        
        
    }
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        // 1
        let placeMarker = marker 
        
        // 2
        if let infoView = UIView.viewFromNibName("MarkerInfoWindow") as? MarkerInfoWindow {
            infoView.addressLabel.text = markerInfo.address
            infoView.coordinateLabel.text = "\(markerInfo.coordinate.latitude ),\n\(markerInfo.coordinate.longitude)"
            //infoView.marker=markerInfo
            // 3
            //infoView.nameLabel.text = placeMarker.place.name
            
            // 4
            //if let photo = placeMarker.place.photo {
            //  infoView.placePhoto.image = photo
            //} else {
            //    infoView.placePhoto.image = UIImage(named: "generic")
            // }
            
            return infoView
        }
        else {
            return nil
        }
    }
    @IBAction func autoCompleteIOS7Controller(segue:UIStoryboardSegue){
        println("autoCompleteIOS7Controller")

        let name = autoCompleteName
        googlePlaceAPI.fetchPlacesDetail(autoCompletePlaceID){ place in
            self.markerInfo = MarkerModel(name: name, coordinate: place!.coordinate, address: place!.address)
            self.mapView.camera = GMSCameraPosition(target: self.markerInfo.coordinate , zoom: 14, bearing: 0, viewingAngle: 0)
            self.mapView.clear()
            var marker = GMSMarker(position: self.markerInfo.coordinate)
            marker.map=self.mapView
        }

    }
    @IBAction func doneTableViewController(segue:UIStoryboardSegue){

    }
    @IBAction func locateTableViewController(segue:UIStoryboardSegue){
        let tableViewController = segue.sourceViewController as!TableViewController
        let selectMarker = tableViewController.selectMarker
        println("locateTableViewController")

        mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: selectMarker.latitude, longitude: selectMarker.longtitude) , zoom: 14, bearing: 0, viewingAngle: 0)
        mapView.clear()
        var marker = GMSMarker(position: CLLocationCoordinate2D(latitude: selectMarker.latitude, longitude: selectMarker.longtitude))
     // marker.title=selectMarker.address
     // marker.snippet="\(selectMarker.coordinate.latitude),\(selectMarker.coordinate.longitude)"
        marker.map=self.mapView
    }
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        //markersData.append(Marker(coordinate: markerInfo.coordinate, address: markerInfo.address))
        //CoreData
        var marker : Marker
        marker = NSEntityDescription.insertNewObjectForEntityForName("Marker", inManagedObjectContext: managedObjectContext!) as!Marker
        marker.name = markerInfo.name
        marker.address = markerInfo.address
        marker.longtitude = markerInfo.coordinate.longitude
        marker.latitude = markerInfo.coordinate.latitude
        marker.note = ""
        //var dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        //var dateString = dateFormatter.stringFromDate(NSDate())
        marker.date=selectedDate
        println("selectedDate=\(selectedDate)")
        var e: NSError?
        if !managedObjectContext!.save(&e){
            println("inser error: \(e!.localizedDescription)")
            return
        }
      //  if let managedObjectContext = (UIApplication.sharedApplication().delegate as!AppDelegate).managedObjectContext{

       // }

    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        println("searchBarSearchButtonClicked")
        if let gotSearchController: AnyClass = NSClassFromString("UISearchController"){
          println("typed:\(searcher.searchBar.text)")
          searcher.active = false
        }
        else {
        
        }
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar){ // wiser:connected the action didSelectRowAtIndexPath in AutoCompleteController , set searcher.active=false as well
        println("searchBarTextDidEndEditing")
        if src.selected! {
            println("autocomplete:\(src.originalData[src.selectedIndex.row]) , \(src.place_ids[src.selectedIndex.row])")
            //descriptionLabel.text="description:"+src.originalData[src.selectedIndex.row]
            //placeidLabel.text="place id:"+src.place_ids[src.selectedIndex.row]
            let name = src.originalData[src.selectedIndex.row]
            googlePlaceAPI.fetchPlacesDetail(src.place_ids[src.selectedIndex.row]){ place in
                //self.coordinateLabel.text="coordinate: \(place!.coordinate.longitude), \(place!.coordinate.latitude)"
                //self.addressLabel.text="address:\(place!.address)"
                self.markerInfo = MarkerModel(name: name, coordinate: place!.coordinate, address: place!.address)
                self.mapView.camera = GMSCameraPosition(target: self.markerInfo.coordinate , zoom: 14, bearing: 0, viewingAngle: 0)
                self.mapView.clear()
                var marker = GMSMarker(position: self.markerInfo.coordinate)
                marker.map=self.mapView
            }
        }
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        println("searchBarTextDidBeginEditing")
        if let gotSearchController: AnyClass = NSClassFromString("UISearchController"){}
        else {
            println("searcher2.setActive")
           // searcher2.setActive(true, animated: true)
        }
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
        println("getInfoFromGMS")
        //self.mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: 35.6894875 , longitude: 139.6917064 ) , zoom: 15, bearing: 0, viewingAngle: 0)
        mapView.camera = GMSCameraPosition(target: markerInfo.coordinate , zoom: 14, bearing: 0, viewingAngle: 0)
        mapView.clear()
        var marker = GMSMarker(position: markerInfo.coordinate)
       // marker.title=markerInfo.address
        
       // marker.snippet="\(markerInfo.coordinate.latitude),\(markerInfo.coordinate.longitude)"
        marker.map=self.mapView
        //print("wiser:\(latitude)\(longtitude)")
        // mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: latitude , longitude: longtitude ) , zoom: 15, bearing: 0, viewingAngle: 0)
        // 6 CLLocationCoordinate2D

    }
    @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
        let segmentedControl = sender as!UISegmentedControl
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("sselectedDate1=\(selectedDate)")
        let fetchRequest = NSFetchRequest(entityName: "Marker")
        var error:NSError?
        
        if selectedDate == nil {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            selectedDate = dateFormatter.stringFromDate(NSDate())
            
        }
        let pred = NSPredicate(format: "(date = %@)", "\(selectedDate)")
        fetchRequest.predicate = pred
        
        markersData = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as![Marker]
        
        if error != nil {
            println("Failed ti retrieve record: \(error!.localizedDescription)")
        }
        //markersData[0].setValue("firstt", forKey: "name")
        //managedObjectContext?.save(&error)
        println("sselectedDate2=\(selectedDate)")
        
        //self.view.insertSubview(searcher.searchBar, atIndex: 1)
        //searcher.searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        /*searchBarView.addConstraint(NSLayoutConstraint(item:  searcher.searchBar , attribute: .Top , relatedBy: .Equal , toItem: searcher.searchBar.superview, attribute: .Top, multiplier: 1.0, constant: 0.0))
        searchBarView.addConstraint(NSLayoutConstraint(item:  searcher.searchBar , attribute: .Leading , relatedBy: .Equal , toItem: searcher.searchBar.superview, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        searchBarView.addConstraint(NSLayoutConstraint(item:  searcher.searchBar , attribute: .Trailing , relatedBy: .Equal , toItem: searcher.searchBar.superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        searcher.searchBar.sizeToFit()
*/
        println("viewWillAppear")
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let gotSearchController: AnyClass = NSClassFromString("UISearchController"){
            println("IOS8:UISearchController")
            // instantiate a search controller and keep it alive
            searcher = UISearchController(searchResultsController: src)
            // specify who the search controller should notify when the search bar changes
            searcher.searchResultsUpdater = src
            
            searcher.searchBar.autocapitalizationType = .None
        
            searcher.searchBar.delegate = self
        
            searchBarView.addSubview(searcher.searchBar)
            searcher.searchBar.sizeToFit()
        }
       else{
            println("IOS7:UISearchDisplayController")
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true

            
            let searchBar = UISearchBar()
            searcher2 = UISearchDisplayController(searchBar: searchBar, contentsController: src2)
            self.view.addSubview(searcher2.searchBar)
            searcher2.searchBar.sizeToFit()
            searcher2.searchResultsDataSource = src2
            searcher2.searchResultsDelegate = src2
            searcher2.delegate = src2
            searcher2.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
            
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.delegate=self
        println("viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

}

