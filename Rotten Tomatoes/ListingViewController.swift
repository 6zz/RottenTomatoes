//
//  ListingViewController.swift
//  Rotten Tomatoes
//
//  Created by Shawn Zhu on 8/27/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftLoader

class ListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var fullListings: NSArray?
    var movies: NSArray?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ErrorView: UIView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ErrorView.hidden = true
        var refreshControl = UIRefreshControl()
        var url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        var request = NSURLRequest(URL: url)
        SwiftLoader.show(animated: true)

        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: "loadMore", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if let error = error {
                self.ErrorView.hidden = false
            } else {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary

                self.movies = responseDictionary["movies"] as? NSArray
                
                self.fullListings = self.movies
                
                self.tableView.rowHeight = 102
                self.tableView.reloadData()
                self.ErrorView.hidden = true
            }
            
            SwiftLoader.hide()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.tumblr.MovieCell", forIndexPath: indexPath) as! MovieCell
        
        if let movies = movies {
            let movie: AnyObject = movies[indexPath.row]
            if let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String) {
                cell.movieImageView.alpha = 0
                cell.movieImageView.setImageWithURL(url)
                UIView.animateWithDuration(1, animations: {
                    cell.movieImageView.alpha = 1
                })
            }
            if let title = movie.valueForKeyPath("title") as? String {
                cell.titleLabel.text = title
            }
            if let rating = movie.valueForKeyPath("mpaa_rating") as? String {
                let attributedSummary = NSMutableAttributedString(string: rating, attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(13.0)])
                
                if let synopsis = movie.valueForKeyPath("synopsis") as? String {
                    let attributedSynopsis = NSMutableAttributedString(string: "  \(synopsis)", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(13.0),
                        NSForegroundColorAttributeName : UIColor.lightTextColor()
                        ])
                    
                    attributedSummary.appendAttributedString(attributedSynopsis)
                    cell.summaryLabel.attributedText = attributedSummary
                } else {
                    cell.summaryLabel.text = rating
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func loadMore() {
        var url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if let error = error {
                self.ErrorView.hidden = false
            } else {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
             
                var more = responseDictionary["movies"] as? NSArray
                
                if let more = more {
                    var size = more.count
                    var lastTwo: NSArray =  more.subarrayWithRange(NSMakeRange(size - 2, 2))
                    self.movies = lastTwo.arrayByAddingObjectsFromArray(self.movies! as [AnyObject])
                    self.tableView.reloadData()
                }
                self.ErrorView.hidden = true
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
    }
    
    func search(needle: String) {
        if needle.isEmpty {
            self.movies = self.fullListings
        } else {
            self.movies = self.fullListings?.filteredArrayUsingPredicate(NSPredicate(format:"%K CONTAINS %@", "title", needle))
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        search("")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let movie: AnyObject = movies![indexPath.row]
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        
        movieDetailsViewController.movie = movie as! NSDictionary
        
        self.movieSearchBar.text = ""
        self.search("")
        self.movieSearchBar.resignFirstResponder()
    }


}
