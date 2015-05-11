//
//  TableViewController.swift
//  Map Tagger
//
//  Created by wiserkuo on 2015/3/11.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController ,UIActionSheetDelegate{
    // Retreive the managedObjectContext from AppDelegate
    @IBOutlet weak var navigationBar: UINavigationItem!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var selectMarker : Marker!
    var selectIndex : NSIndexPath!
    var datePicker : UIDatePicker!
    var actionSheet : UIActionSheet!
    
    func createDatePickerViewWithAlertController()
    {
        var viewDatePicker: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        viewDatePicker.backgroundColor = UIColor.clearColor()
        self.datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        
        //self.datePicker.addTarget(self, action: "datePickerSelected", forControlEvents: UIControlEvents.ValueChanged)
        viewDatePicker.addSubview(self.datePicker)
        if(UIDevice.currentDevice().systemVersion >= "8.0")
        {
            
            let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alertController.view.addSubview(viewDatePicker)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
                { (action) in
                    // ...
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Done", style: .Default)
                { (action) in
                    
                    self.dateSelected()
                    println("Done selectedDate=\(selectedDate)")
            }
            alertController.addAction(OKAction)
            
            /*
            let destroyAction = UIAlertAction(title: "Destroy", style: .Destructive)
            { (action) in
            println(action)
            }
            alertController.addAction(destroyAction)
            */
            self.presentViewController(alertController, animated: true)
                {
                    // ...
            }
        }
        else
        {
            println("UIAlertSheet")
            actionSheet = UIActionSheet(title: "\n\n\n\n\n\n\n\n\n\n", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil )
            
            self.datePicker.frame.origin.y = 44
            
            var pickerDateToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
            
            pickerDateToolbar.barStyle = UIBarStyle.Black
            
            var barItems = NSMutableArray()
            
            var doneButton = UIBarButtonItem(title: "Done",style: UIBarButtonItemStyle.Done, target: self, action: "doneIOS7Date:")
            
            barItems.addObject(doneButton)
            
            var cancelButton = UIBarButtonItem(title: "Cancel",style: UIBarButtonItemStyle.Plain, target: self, action: "cancelIOS7Date:")
            
            barItems.addObject(cancelButton)
            
            pickerDateToolbar.setItems(barItems as [AnyObject], animated: true)
            
            actionSheet.addSubview(pickerDateToolbar)
            
            actionSheet.addSubview(datePicker)
            
            actionSheet.showInView(self.view)

        }
        
    }
    func doneIOS7Date(doneButton: UIBarButtonItem){
        println("done")
        self.dateSelected()
        println("Done selectedDate=\(selectedDate)")
        actionSheet.dismissWithClickedButtonIndex(0, animated: true)
    }
    func cancelIOS7Date(doneButton: UIBarButtonItem){
        println("cancel")
    }
    func dateformatterDateTime(date: NSDate) -> NSString
    {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    func dateSelected()
    {
       // var selectedDate: String = String()
        selectedDate = self.dateformatterDateTime(datePicker.date) as String
        self.title = selectedDate
        
        let fetchRequest = NSFetchRequest(entityName: "Marker")
        var error:NSError?
        
        let pred = NSPredicate(format: "(date = %@)", "\(selectedDate)")
        fetchRequest.predicate = pred
        
        let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [Marker]?
        if let results = fetchResults {
            markersData = results
            
        }
        self.tableView.reloadData()
       // self.textFieldFromDate.text =  selectedDate
       println("dateSelected() selectedDate=\(selectedDate)")
    }

    @IBAction func selectDate(sender: AnyObject) {
        createDatePickerViewWithAlertController()
        /*let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println(action)
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            println(action)
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }*/
    }
    @IBAction func cancelFromEdit(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveFromEdit(segue:UIStoryboardSegue) {
        println("saveFromEdit")
        let editVC = segue.sourceViewController as! EditCellTableViewController
        self.selectIndex = self.tableView.indexPathForSelectedRow()
        markersData[self.selectIndex.row].name=editVC.selectedMarker.name
        markersData[self.selectIndex.row].note=editVC.selectedMarker.note
        markersData[self.selectIndex.row].photo=editVC.selectedMarker.photo
        markersData[self.selectIndex.row].hasPhoto = editVC.selectedMarker.hasPhoto
        println("hasPhoto=\( markersData[self.selectIndex.row].hasPhoto)")
        var e: NSError?
        if !managedObjectContext.save(&e){
            println("inser error: \(e!.localizedDescription)")
            return
        }
        tableView.reloadData()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
println("selectedDate1=\(selectedDate)")
        let fetchRequest = NSFetchRequest(entityName: "Marker")
        var error:NSError?
        
        if selectedDate == nil {
          var dateFormatter = NSDateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          selectedDate = dateFormatter.stringFromDate(NSDate())
          
        }
        let pred = NSPredicate(format: "(date = %@)", "\(selectedDate)")
        fetchRequest.predicate = pred
        
        let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [Marker]?
        if let results = fetchResults {
            markersData = results
            
        }
        else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        println("selectedDate2=\(selectedDate)")
        self.title=selectedDate
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
        
      //  var dateFormatter = NSDateFormatter()
      //  dateFormatter.dateFormat = "yyyy-MM-dd"
      //  self.title=dateFormatter.stringFromDate(date)
        
            //navigationBar.title=dateFormatter.stringFromDate(date)
        //var strDate = dateFormatter.stringFromDate(datepicker.date)
   //     self.label.text = strDate
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MarkerCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let marker = markersData[indexPath.row] 
        cell.textLabel!.text = marker.valueForKey("name") as! String!
        cell.detailTextLabel!.text=marker.valueForKey("address") as! String!
        cell.imageView!.image = UIImage(data: marker.valueForKey("photo") as! NSData )
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
        println("seguee=\(segue.identifier)")
        if segue.identifier == "locateSegue" {
          //  println("row\(self.tableView.indexPathForSelectedRow()?.row)")
           selectMarker = markersData[self.selectIndex.row]
           println("hasPhoto=\(selectMarker.hasPhoto)")
        }
        if segue.identifier == "editMarkerSegue" {
            
           let editCellTableViewController = segue.destinationViewController as! EditCellTableViewController
            println("index=\(self.tableView.indexPathForSelectedRow()?.row)")
           
            editCellTableViewController.selectedMarker = markersData[self.tableView.indexPathForSelectedRow()!.row]
        
        }
    }
    

}
