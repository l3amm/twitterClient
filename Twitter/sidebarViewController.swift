//
//  sidebarViewController.swift
//  Twitter
//
//  Created by Scott Woody on 10/5/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class sidebarViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    var timelineVC: TweetsViewController!
    var mentionsVC: TweetsViewController!
    var profileVC: TweetsViewController!
    
    @IBOutlet weak var mentionsButton: UIButton!
    @IBOutlet weak var timelineButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var contentXConstraint: NSLayoutConstraint!
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil){
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        timelineVC = sb.instantiateViewControllerWithIdentifier("TimelineViewController") as TweetsViewController
        mentionsVC = sb.instantiateViewControllerWithIdentifier("TimelineViewController") as TweetsViewController
        profileVC = sb.instantiateViewControllerWithIdentifier("TimelineViewController") as TweetsViewController
        profileVC.displayProfile = true
        self.activeViewController = timelineVC
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sidebarButtonTapped(sender: UIButton) {
        if sender == mentionsButton {
            self.activeViewController = mentionsVC
        } else if sender == profileButton {
            self.activeViewController = profileVC
        } else if sender == timelineButton {
            self.activeViewController = timelineVC
        }
        // Reload the tweets data on the activeViewController
        (self.activeViewController as TweetsViewController).refreshTweets()
        // Close the tray, should upgrade to an animation
        contentXConstraint.constant = 0
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let xOffset = sender.translationInView(self.view).x
        if xOffset < 0 {
            return
        }

        if sender.state == .Ended && xOffset > 50 {
            contentXConstraint.constant = -120
        } else if sender.state == .Ended && xOffset <= 50 {
            contentXConstraint.constant = 0
        } else if xOffset < 120 {
            contentXConstraint.constant = -xOffset
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
