//
//  FeedbackController.swift
//  sunshine
//
//  Created by Airing on 16/8/18.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit

class FeedbackController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let mainColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.hideBottomHairline()
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        self.webview.loadRequest(NSURLRequest(URL:NSURL(string:"http://sunnybaby.ursb.me/")!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
