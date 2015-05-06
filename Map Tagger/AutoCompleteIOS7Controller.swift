//
//  AutoCompleteIOS7Controller.swift
//  Map Tagger
//
//  Created by wiserkuo on 2015/5/5.
//  Copyright (c) 2015年 sw5. All rights reserved.
//
import UIKit

class AutoCompleteIOS7Controller: UITableViewController , UISearchBarDelegate, UISearchDisplayDelegate {
    //var filteredCandies = [Candy]()
    var originalData : [String] = []
    var place_ids : [String] = []
    var filteredData : [String] = []
    var googlePlaceAPI = GooglePlaceAPI()
    var selectedIndex = NSIndexPath()
    var selected : Bool!
    var emptyData : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //if tableView == searcher2!.searchResultsTableView {
            return self.filteredData.count
        //}
        //return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //same String "Cell" with the tableviewcell's identifier , set in storyboard->attribute inspector
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        println("indexPath=\(indexPath.row)")
        var result : String
        
        //if tableView == searcher2!.searchResultsTableView {
            
        result = filteredData[indexPath.row]
        //} else {
        //    result = emptyData[indexPath.row]
        //}
        cell.textLabel?.text = result
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        // Configure the cell...
            
        return cell
    }
    override func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("select")
        selectedIndex=indexPath
        selected = true
        searcher2.active=false
    }

    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {

        selected = false
        var downloadGroup = dispatch_group_create()
        dispatch_group_enter(downloadGroup)
        self.googlePlaceAPI.fetchPlacesAutoComplete(searchString){ predictions in

            self.place_ids.removeAll()
            self.filteredData.removeAll()
            for prediction: Prediction in predictions {
                //println("\(prediction.description)")
                //      self.sectionData.append(prediction.description)
                self.filteredData.append(prediction.description)
                //println("prediction:\(prediction.description)")
                self.place_ids.append(prediction.place_id)
            }
            println("filteredData.last=\(self.filteredData.last)")
            dispatch_group_leave(downloadGroup)
        }
       
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER)
        println("end")
        return true
    }
    /*func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as! [String]
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
        
        //self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }*/
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        /*if segue.identifier == "candyDetail" {
            let candyDetailViewController = segue.destinationViewController as! UIViewController
            if sender?.tableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredCandies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = candies[indexPath.row].name
                candyDetailViewController.title = destinationTitle
            }
        }*/
        println("segue=\(segue.identifier)")
        if segue.identifier == "autoCompleted" {
            let mapViewController = segue.destinationViewController as! ViewController
            mapViewController.autoCompleteName = filteredData[self.selectedIndex.row]
            mapViewController.autoCompletePlaceID = place_ids[self.selectedIndex.row]
            println("row\(self.selectedIndex.row)")
            println("description=\(filteredData[self.selectedIndex.row])")
            println("placeid=\(place_ids[self.selectedIndex.row])")
        }
    }
    
    
}