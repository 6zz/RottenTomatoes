//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Shawn Zhu on 8/28/15.
//  Copyright (c) 2015 Shawn Zhu. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        let title = movie["title"] as! String
        let year = movie["year"] as! Int
        let ratings = movie["ratings"] as! NSDictionary
        let criticsScore = ratings["critics_score"] as! Int
        let audienceScore = ratings["audience_score"] as! Int
        var urlStr = movie.valueForKeyPath("posters.thumbnail") as! String
        let lowresImage = UIImage(data: NSData(contentsOfURL: NSURL(string: urlStr)!)!)
            
        titleLabel.text = "\(title) (\(year))"
        ratingLabel.text = movie["mpaa_rating"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        scoreLabel.text = "Critics score: \(criticsScore), Audience score: \(audienceScore)"
        
        var range = urlStr.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlStr = urlStr.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        if let url = NSURL(string: urlStr) {
            bgImageView.setImageWithURL(url, placeholderImage: lowresImage)
        }

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

}
