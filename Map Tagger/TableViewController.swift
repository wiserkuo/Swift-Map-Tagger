//
//  TableViewController.swift
//  Map Tagger
//
//  Created by wiserkuo on 2015/3/11.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var selectMarker : Marker!
    var selectIndex : NSIndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return markersData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MarkerCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let marker = markersData[indexPath.row] as Marker
        cell.textLabel?.text = marker.address
        cell.detailTextLabel?.text="\(marker.coordinate.latitude) , \(marker.coordinate.longitude)"
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            markersData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert{
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var locateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Locate" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.selectIndex = indexPath
            self.performSegueWithIdentifier("locateSegue", sender: self)
            
            // 2
            //let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            //let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
            //let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            //shareMenu.addAction(twitterAction)
            //shareMenu.addAction(cancelAction)
            //self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        locateAction.backgroundColor=UIColor.greenColor()
        // 3
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            markersData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // 4
            //let rateMenu = UIAlertController(title: nil, message: "Rate this App", preferredStyle: .ActionSheet)
            //let appRateAction = UIAlertAction(title: "Rate", style: UIAlertActionStyle.Default, handler: nil)
            //let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            //rateMenu.addAction(appRateAction)
            //rateMenu.addAction(cancelAction)
            //self.presentViewController(rateMenu, animated: true, completion: nil)
        })
        // 5
        return [deleteAction,locateAction]
    }
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
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "locateSegue" {
           selectMarker = markersData[self.selectIndex.row]
           
        }
        
    }
    

}
