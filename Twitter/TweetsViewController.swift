//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Scott Woody on 9/27/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

enum StreamType {
    case Home, Mention, User
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sidebarVC: sidebarViewController!
    
    var displayProfile = false
    var tweetStreamType: StreamType = StreamType.Home // Default value
    var refreshControl: UIRefreshControl!
    var tweets: [Tweet]?
    
    @IBOutlet weak var profileHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetTableView: UITableView!
    
    //Used for the profile view
    var profileUser: User!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var userScreennameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshTweets", forControlEvents: UIControlEvents.ValueChanged)
        tweetTableView.addSubview(self.refreshControl)
        
        if displayProfile == false {
            profileHeightConstraint.constant = 0
        }
        
        tweetTableView.estimatedRowHeight = 80
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        refreshTweets()
        updateProfile()
    }
    
    func updateProfile(){
        if profileUser != nil {
            userNameLabel.text = profileUser.name
            userScreennameLabel.text = "@\(profileUser.screenname!)"
            followerCountLabel.text = "\(profileUser.followerCount!)"
            followingCountLabel.text = "\(profileUser.followingCount!)"
            tweetCountLabel.text = "\(profileUser.tweetCount!)"
            let profileURL = NSURL(string: profileUser.profileImageURL!)
            userImageView.setImageWithURL(profileURL)
        }
    }
    
    func refreshTweets(){
        // We use different API endpoints depending on whether we are looking at our home, a user timeline or our mention timeline
        switch tweetStreamType {
        case .Home:
            TwitterClient.sharedInstance.loadHomeTimeline(nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tweetTableView.reloadData()
            })

        case .Mention:
            TwitterClient.sharedInstance.loadMentionsTimeline(nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tweetTableView.reloadData()
            })

        case .User:
            TwitterClient.sharedInstance.loadUserTimeline(nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tweetTableView.reloadData()
            })

        }
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
        cell.vc = self
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let tweet = tweets![indexPath.row]
        cell.user = tweet.user!
        let profileURL = NSURL(string: tweet.user!.profileImageURL!)
        cell.profilePicImageView.setImageWithURL(profileURL)
        cell.nameLabel.text = tweet.user!.name
        cell.dateLabel.text = tweet.createdAtString
        cell.tweetTextLabel.text = tweet.text
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tweetCount = 0
        if tweets != nil {
            tweetCount = tweets!.count
        }
        return tweetCount

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
    
    func changeUser(user: User){
        // pass through method from cell -> sidebar
        sidebarVC.showUserTimeline(user)
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
