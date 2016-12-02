//
//  ThirdViewController.swift
//  adamapp
//
//  Created by Max Kerscher-Santelli on 7/7/16.
//  Copyright © 2016 Max Kerscher-Santelli. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("switched to hypermedia page")
        
        //set preferences for loading animation while page loads
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.layer.cornerRadius = 3.0
        loadingAnimation.color = UIColor(white: 1, alpha: 1)
        loadingAnimation.startAnimating()
        
        webView.delegate = self
        
        //set webpage to load
        let url = URL(string: "https://tbccurates.squarespace.com/hypermedia-1")
        let request = URLRequest(url: url!)
        
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        //remove loading animation once webpage is loaded
        print("Finished Loading hypermedia")
        loadingView.isHidden = true
        loadingAnimation.isHidden = true
    }

}
