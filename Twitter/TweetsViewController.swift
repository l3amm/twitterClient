//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Scott Woody on 9/27/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refreshControl: UIRefreshControl!
    var tweets: [Tweet]?

    @IBOutlet weak var tweetTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshTweets", forControlEvents: UIControlEvents.ValueChanged)
        tweetTableView.addSubview(self.refreshControl)
        
        tweetTableView.estimatedRowHeight = 80
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        refreshTweets()
    }
    
    func refreshTweets(){
        TwitterClient.sharedInstance.loadUserTimeline(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tweetTableView.reloadData()
        })
        self.refreshControl.endRefreshing()
    }

    @IBAction func newTweet(sender: AnyObject) {
        performSegueWithIdentifier("newTweetSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tweetTableView.dequeueReusableCellWithIdentifier("tweetTableViewCell") as TweetTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let tweet = tweets![indexPath.row]
        let profileURL = NSURL(string: tweet.user!.profileImageURL!)
        cell.profilePicImageView.setImageWithURL(profileURL)
        cell.nameLabel.text = tweet.user!.name
        cell.dateLabel.text = tweet.createdAtString
        cell.tweetTextLabel.text = tweet.text
        return cell
    }
    
    @IBAction func didPan(sender: AnyObject) {
        println("panning")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Perform a segue to the details
        let tweet = tweets![indexPath.row]
        performSegueWithIdentifier("tweetDetailSegue", sender: tweet)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tweetDetailSegue" {
            let vc = segue.destinationViewController as TweetDetailViewController
            let tweet = sender as Tweet
            vc.tweet = tweet
        } else if segue.identifier == "newTweetSegue" {
            println("we doing a new tweet")
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
