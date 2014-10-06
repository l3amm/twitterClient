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
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                println(newVC)
                println("heere")
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentView.bounds
                println("stuff")
                self.contentView.addSubview(newVC.view)
                println("things")
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("TweetsViewController") as TweetsViewController
        self.activeViewController = vc
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
