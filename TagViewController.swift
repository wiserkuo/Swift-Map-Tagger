//
//  TagViewController.swift
//  Map Tagger
//
//  Created by wiserkuo on 2015/5/12.
//  Copyright (c) 2015年 sw5. All rights reserved.
//

import UIKit

class TagViewController: UIViewController {
    
    
    
    @IBAction func tagHere(segue:UIStoryboardSegue){
        println("tagHere")
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //super.prepareForSegue(segue, sender: sender)
        println("seguee=\(segue.identifier)")
        if segue.identifier == "tagSegue" {
            let VC = segue.destinationViewController as! ViewController
            VC.isFromTageHere = true
        }
        
    }
}
