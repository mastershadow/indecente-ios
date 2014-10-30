//
//  ViewController.swift
//  Indecente
//
//  Created by Eduard Roccatello on 01/10/14.
//  Copyright (c) 2014 Roccatello Eduard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var indecente:UIImageView? = nil
    @IBOutlet var render:UIImageView? = nil
    @IBOutlet var bg:UIImageView? = nil
    @IBOutlet var menuView:UIView? = nil
    
    @IBOutlet var playButton:IndButton? = nil
    @IBOutlet var copioneButton:IndButton? = nil
    @IBOutlet var castButton:IndButton? = nil
    @IBOutlet var galleryButton:IndButton? = nil
    @IBOutlet var newsButton:IndButton? = nil
    @IBOutlet var trailerButton:IndButton? = nil
    
    @IBOutlet var creditsButton:UIButton? = nil
    
    @IBOutlet var menuViewRightMarginContraint:NSLayoutConstraint? = nil
    @IBOutlet var titleRightMarginConstraint:NSLayoutConstraint? = nil
    @IBOutlet var leftButtonLeftMarginConstraint:NSLayoutConstraint? = nil
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        bg?.image = UIImage(named: "indecente_bg.jpg")

        trailerButton?.addTarget(self, action: "onTrailer", forControlEvents: UIControlEvents.TouchUpInside)
        copioneButton?.addTarget(self, action: "onCopione", forControlEvents: UIControlEvents.TouchUpInside)
        castButton?.addTarget(self, action: "onCast", forControlEvents: UIControlEvents.TouchUpInside)
        newsButton?.addTarget(self, action: "onNews", forControlEvents: UIControlEvents.TouchUpInside)
        galleryButton?.addTarget(self, action: "onGallery", forControlEvents: UIControlEvents.TouchUpInside)
        creditsButton?.addTarget(self, action: "onCredits", forControlEvents: UIControlEvents.TouchUpInside)
        
        menuViewRightMarginContraint?.constant = 142
        titleRightMarginConstraint?.constant = 180
        leftButtonLeftMarginConstraint?.constant = -85
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true;
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.menuViewRightMarginContraint?.constant = 0
            self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.titleRightMarginConstraint?.constant = 0
            self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.leftButtonLeftMarginConstraint?.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // animating
    }

    func onTrailer() {
        UIApplication.sharedApplication().openURL(NSURL(string : "https://www.youtube.com/watch?v=eqI0LE9UpsE")!);
    }
    
    func onCopione() {
        pushWebViewWithUrl(INDECENTE_BASE_URL + "/copione.html", title: "Estratti dal Copione")
    }
    
    func onCredits() {
        pushWebViewWithUrl(INDECENTE_BASE_URL + "/credits/credits.html", title:  "Behind the App")
    }
    
    func onCast() {
        pushWebViewWithUrl(INDECENTE_BASE_URL + "/cast.html", title: "Il Cast")
    }
    
    func onNews() {
        pushWebViewWithUrl(INDECENTE_BASE_URL + "/news.html", title: "News & Eventi")
    }
    
    func pushWebViewWithUrl(url: String, title: String) -> Void {
        var webView = WebViewController(url: url, title: title)
        navigationController?.pushViewController(webView, animated: true)
    }
    
    func onGallery() {
        var phVc = PhotoViewController()
        navigationController?.pushViewController(phVc, animated: true)
    }
    
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue);
    }

}

