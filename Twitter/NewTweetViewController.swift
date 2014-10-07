//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Scott Woody on 9/28/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    
    var retweetTweet: Tweet?

    @IBOutlet weak var bottomTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHidden", name: UIKeyboardDidHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
        nameLabel.text = User.currentUser!.name
        let profileURL = NSURL(string: User.currentUser!.profileImageURL!)
        profileView.setImageWithURL(profileURL)
        
        if retweetTweet != nil {
            self.navigationItem.title = "Reply"
            tweetText.text = "@\(retweetTweet!.user!.screenname!)"
        } else {
            self.navigationItem.title = "Post"
            tweetText.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardShown (){
        bottomTextConstraint.constant = 260
    }
    
    func keyboardHidden () {
        bottomTextConstraint.constant = 8
    }
    
    @IBAction func writeTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweet(tweetText.text, completion: { (error) -> () in
            println("we finished")
            self.navigationController?.popViewControllerAnimated(true)

        })
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
