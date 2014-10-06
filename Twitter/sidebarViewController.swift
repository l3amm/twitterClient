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
    
    var tweetsViewController = TweetsViewController(nibName: nil, bundle: nil)
    
    @IBOutlet weak var contentXConstraint: NSLayoutConstraint!
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil){
            println("heheh")
            println(oldViewControllerOrNil)
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
                println(oldVC)
            }
            if let newVC = activeViewController {
                println(newVC)
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
        self.activeViewController = tweetsViewController
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
