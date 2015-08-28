//
//  ListingViewController.swift
//  Rotten Tomatoes
//
//  Created by Shawn Zhu on 8/27/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class ListingViewController: UIViewController {
    var movies: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary

            self.movies = responseDictionary["movies"] as? NSArray
//            self.tableView.reloadData()
            
            NSLog("response: \(self.movies)")
        }
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

}
