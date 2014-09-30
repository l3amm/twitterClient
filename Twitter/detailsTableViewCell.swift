//
//  detailsTableViewCell.swift
//  Twitter
//
//  Created by Scott Woody on 9/28/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class detailsTableViewCell: UITableViewCell {
    
    var tweet: Tweet!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
