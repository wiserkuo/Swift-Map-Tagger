//
//  TableViewController.swift
//  Map Tagger
//
//  Created by wiserkuo on 2015/3/11.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController {
    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var selectMarker : Marker!
    var selectIndex : NSIndexPath!
    @IBAction func cancelFromEdit(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveFromEdit(segue:UIStoryboardSegue) {
        let editVC = segue.sourceViewController as EditCellTableViewController
        self.selectIndex = self.tableView.indexPathForSelectedRow()
        markersData[self.selectIndex.row].name=editVC.selectedMarker.name
        markersData[self.selectIndex.row].note=editVC.selectedMarker.note
        var e: NSError?
        if !managedObjectContext.save(&e){
            println("inser error: \(e!.localizedDescription)")
            return
        }
        tableView.reloadData()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        let fetchRequest = NSFetchRequest(entityName: "Marker")
        var error:NSError?
        let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as [Marker]?
        if let results = fetchResults {
            markersData = results
            
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        //if error != nil {
        //    println("Failed ti retrieve record: \(error!.localizedDescription)")
        //}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let date=NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        components.month=2
        
        //println("let \(calendar.rangeOfUnit( .CalendarUnitDay, inUnit: .CalendarUnitMonth, forDate: calendar.dateFromComponents(components)!).length)")
        
        println("dsjifoidsfudsuffds \(components.year) \(components.month) \(components.day)")
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
        let marker = markersData[indexPath.row] 
        cell.textLabel!.text = marker.valueForKey("name") as String?
        cell.detailTextLabel!.text=marker.valueForKey("address") as String?
       // cell.detailTextLabel?.text="\(marker.coordinate.latitude) , \(marker.coordinate.longitude)"
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

            println("indexPath=\(indexPath.row)")
            self.managedObjectContext.deleteObject(markersData[indexPath.row]) //delete coredata
            markersData.removeAtIndex(indexPath.row)                           //then delete tableview data source , or the index will wrong
            var e: NSError?
            if !self.managedObjectContext.save(&e){
                println("inser error: \(e!.localizedDescription)")
                return
            }
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
        //super.prepareForSegue(segue, sender: sender)
        println("segue=\(segue.identifier)")
        if segue.identifier == "locateSegue" {
           selectMarker = markersData[self.tableView.indexPathForSelectedRow()!.row]
           
        }
        if segue.identifier == "editMarkerSegue" {
            
           let editCellTableViewController = segue.destinationViewController as EditCellTableViewController
            
            println("index=\(self.tableView.indexPathForSelectedRow()?.row)")
           
            editCellTableViewController.selectedMarker = markersData[self.tableView.indexPathForSelectedRow()!.row]
            
        }
    }
    

}
