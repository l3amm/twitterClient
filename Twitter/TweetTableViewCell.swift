//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Scott Woody on 9/28/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    var user: User!
    var vc: TweetsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicImageView.image = UIImage(named: "twitterIcon.png")
        // Direct a click on the profilePic to the users timeline
        let picTap = UITapGestureRecognizer(target: self, action: "loadUserTimeline")
        picTap.numberOfTapsRequired = 1
        profilePicImageView.addGestureRecognizer(picTap)
        profilePicImageView.userInteractionEnabled = true
    }
    
    func loadUserTimeline(){
        vc.changeUser(user)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
