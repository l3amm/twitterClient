//
//  retweetTableViewCell.swift
//  Twitter
//
//  Created by Scott Woody on 9/28/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit
let retweetTweet = "retweetTweet"

class retweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet!

    override func awakeFromNib() {
        super.awakeFromNib()

        replyImage.image = UIImage(named: "iconmonstr-arrow-58-icon-32.png")
        retweetImage.image = UIImage(named: "iconmonstr-retweet-icon-32.png")
        faveImage.image = UIImage(named: "iconmonstr-star-5-icon-32.png")
        
        let replyTap = UITapGestureRecognizer(target: self, action: "handleReply")
        replyTap.numberOfTapsRequired = 1
        replyImage.addGestureRecognizer(replyTap)
        replyImage.userInteractionEnabled = true
        
        let retweetTap = UITapGestureRecognizer(target: self, action: "handleRetweet")
        retweetTap.numberOfTapsRequired = 1
        retweetImage.addGestureRecognizer(retweetTap)
        retweetImage.userInteractionEnabled = true
        
        let faveTap = UITapGestureRecognizer(target: self, action: "handleFave")
        faveTap.numberOfTapsRequired = 1
        faveImage.addGestureRecognizer(faveTap)
        faveImage.userInteractionEnabled = true
    }

    @IBOutlet weak var faveImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    
    func handleReply() {
        NSNotificationCenter.defaultCenter().postNotificationName(retweetTweet, object: nil)
    }
    
    func handleRetweet() {
        TwitterClient.sharedInstance.retweet(tweet.id!, completion: { (error) -> () in
            // Replace the icon with a retweeted icon
            if error == nil{
                self.retweetImage.image = UIImage(named: "iconmonstr-retweet-icon-32-green.png")
            }
        })
    }
    
    func handleFave() {
        TwitterClient.sharedInstance.fave(tweet.id!, completion: { (error) -> () in
            if error == nil {
                self.faveImage.image = UIImage(named: "iconmonstr-star-5-icon-32-gold.png")
            } else {
                println("failed to fave")
            }
        })
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
