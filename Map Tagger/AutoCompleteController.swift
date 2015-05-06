//
//  AutoCompleteController.swift
//  SearchController
//
//  Created by wiserkuo on 2015/4/22.
//  Copyright (c) 2015年 wiserkuo. All rights reserved.
//

import UIKit

class AutoCompleteController: UITableViewController {
    var originalData : [String] = []
    var place_ids : [String] = []
    var filteredData : [String] = []
    var googlePlaceAPI = GooglePlaceAPI()
    var selectedIndex = NSIndexPath()
    var selected : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    override func viewDidAppear(animated: Bool) {
    
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
        return self.filteredData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = self.filteredData[indexPath.row]
        println("indexPath=\(indexPath.row)")

        // Configure the cell...

        return cell
    }
    override func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex=indexPath
        selected = true
        searcher.active=false
        
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSegue")
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
/*
This is the only other interesting part!
We are the searchResultsUpdater, which simply means that our
updateSearchResultsForSearchController is called every time something happens
in the search bar. So, every time it is called,
filter the original data in accordance with what's in the search bar,
and reload the table.
*/

extension AutoCompleteController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        println("updateSearchResultsForSearchController")
        selected = false
        self.originalData.removeAll()
        self.place_ids.removeAll()
        self.filteredData.removeAll()
        googlePlaceAPI.fetchPlacesAutoComplete(searchController.searchBar.text){ predictions in
            for prediction: Prediction in predictions {
                //println("\(prediction.description)")
                //      self.sectionData.append(prediction.description)
                self.filteredData.append(prediction.description)
                self.place_ids.append(prediction.place_id)
            }
            println("\(self.filteredData.last)")
            println("reloadData")
            self.tableView.reloadData()
        }
    }
}