//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Scott Woody on 9/28/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweet: Tweet!

    @IBOutlet weak var detailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.estimatedRowHeight = 80
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.tableFooterView = UIView(frame: CGRectZero)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showRetweet", name: retweetTweet, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showRetweet() {
        performSegueWithIdentifier("replyToTweet", sender: tweet)
        println("showing retweet")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tweet = sender! as Tweet
        let vc = segue.destinationViewController as NewTweetViewController
        vc.retweetTweet = tweet
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Detail table cell
            let cell = detailTableView.dequeueReusableCellWithIdentifier("tweetDetails") as detailsTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.nameLabel.text = tweet.user!.name
            cell.tweetLabel.text = tweet.text
            cell.dateLabel.text = tweet.createdAtString
            let picURL = NSURL(string:tweet.user!.profileImageURL!)
            cell.profileImage.setImageWithURL(picURL)
            cell.tweet = tweet!
            return cell
        } else {
            // Show retweetPanel
            let cell = detailTableView.dequeueReusableCellWithIdentifier("retweetPanel") as retweetTableViewCell
            cell.tweet = tweet!
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
