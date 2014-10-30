//
//  WebViewController.swift
//  Indecente
//
//  Created by Eduard Roccatello on 01/10/14.
//  Copyright (c) 2014 Roccatello Eduard. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController, UIGestureRecognizerDelegate, UIWebViewDelegate, UIAlertViewDelegate {
    var webview:UIWebView!
    var urlString:String?
    
    convenience init(url: String, title: String) {
        self.init()
        self.urlString = url
        self.title = title
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        
        self.webview = UIWebView()
        self.webview.opaque = false
        self.webview.delegate = self
        self.webview.backgroundColor = UIColor.blackColor()
        self.webview.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth;
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.webview);
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "onWebViewTap")
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.webview.addGestureRecognizer(tapGesture);
        
        var swipeBack = UISwipeGestureRecognizer(target: self, action: "onSwipeBack")
        swipeBack.numberOfTouchesRequired = 1
        swipeBack.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipeBack)
    }
    
    func onSwipeBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func onWebViewTap() {
        if self.navigationController!.navigationBarHidden {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.urlString != nil {
            openUrl(self.urlString!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webview.frame = self.view.bounds;
    }
    
    func openUrl(u: String) -> Void {
        self.webview.loadRequest(NSURLRequest(URL: NSURL(string: u)!))
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        var response:NSURLResponse?
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil);
        if let httpResponse = response as? NSHTTPURLResponse {
            if (httpResponse.statusCode == 404) {
                self.webView(webView, didFailLoadWithError: NSError())
                return false;
            }
        }
        
        return true;
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        var alert = UIAlertView()
        alert.title = "Questo è Indecente!"
        alert.message = "Non riesco a connettermi al server.\nSei connesso a Internet?"
        alert.addButtonWithTitle("Ok")
        alert.delegate = self
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue);
    }
}

