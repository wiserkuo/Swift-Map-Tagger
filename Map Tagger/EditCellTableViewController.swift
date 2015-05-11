//
//  EditCellTableViewController.swift
//  Map Tagger
//
//  Created by Wiser Kuo on 2015/3/23.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import UIKit

class EditCellTableViewController: UITableViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var selectedMarker : Marker!
 
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    

    @IBOutlet weak var photoView: UIView!
    var imageView : UIImageView!
    var image :UIImage!
    
    @IBAction func carmeraTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func galleryTapped(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.image = image
        println("didFinishPickingImage")
    
        imageView = UIImageView(frame: CGRectMake(0, 0, photoView.frame.size.width, photoView.frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
       
         photoView.addSubview(imageView)
         //photoView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: photoView, attribute: .Top, multiplier: 1.0, constant: 0.0))
         //photoView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: photoView, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
         //photoView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: photoView, attribute: .Leading, multiplier: 1.0, constant: 0.0))
         //photoView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: photoView, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
         imageView.image = image
        self.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera ) {
            UIImageWriteToSavedPhotosAlbum( UIImage(data: UIImageJPEGRepresentation(image, 0.6)), nil, nil, nil)
            var alert = UIAlertView(title: "Wow",
                message: "Your image has been saved to Photo Library!",
                delegate: nil,
                cancelButtonTitle: "Ok")
            alert.show()
        }
        selectedMarker.hasPhoto = 1
        selectedMarker.photo = UIImagePNGRepresentation(image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("selectedMarker=\(selectedMarker.address)")
        coordinateLabel.text="\(selectedMarker.latitude) ,\(selectedMarker.longtitude)"
        addressLabel.text=selectedMarker.address
        nameTextField.text=selectedMarker.name
        notesTextField.text=selectedMarker.note
         //image = UIImage(named: "default")
        //var imageView = UIImageView(image: image)

        //imageView.contentMode = UIViewContentMode.Right
        //photoView.addSubview(imageView)
       // photoView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: imageView.superview, attribute: .Top, multiplier: 1.0, constant: 0.0))
       // photoView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: imageView.superview, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
       // photoView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: imageView.superview, attribute: .Leading, multiplier: 1.0, constant: 0.0))
       // photoView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: imageView.superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        /*searchBarView.addConstraint(NSLayoutConstraint(item:  searcher.searchBar , attribute: .Top , relatedBy: .Equal , toItem: searcher.searchBar.superview, attribute: .Top, multiplier: 1.0, constant: 0.0))
        searchBarView.addConstraint(NSLayoutConstraint(item:  searcher.searchBar , attribute: .Leading , relatedBy: .Equal , toItem: searcher.searchBar.superview, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        searchBarView.addConstraint(NSLayoutConstraint(item:  searcher.searchBar , attribute: .Trailing , relatedBy: .Equal , toItem: searcher.searchBar.superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        searcher.searchBar.sizeToFit()
        */

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear hasPhoto=\(selectedMarker.hasPhoto)")
        if selectedMarker.hasPhoto == 1 {
            println("image")
            imageView = UIImageView(frame: CGRectMake(0, 0, photoView.frame.size.width, photoView.frame.size.height))
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            photoView.addSubview(imageView)
            imageView.image = UIImage(data: selectedMarker.photo)
            self.image = UIImage(data: selectedMarker.photo)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
*/
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
        if segue.identifier == "saveFromEditSegue" {
            println("EditMarkerVC:prepareForSegue")
            selectedMarker.name = self.nameTextField.text
            selectedMarker.note = self.notesTextField.text
            
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
    }
    

}
