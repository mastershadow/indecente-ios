//
//  IndButton.swift
//  Indecente
//
//  Created by Eduard Roccatello on 11/10/14.
//  Copyright (c) 2014 Roccatello Eduard. All rights reserved.
//

import UIKit

class IndButton : UIButton {
    override init() {
        super.init()
        initButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        let redColor = UIColor(red: 0.85, green: 0, blue: 0, alpha: 1.0)
        let whiteColor = UIColor(white: 1, alpha: 0.9)
        backgroundColor = whiteColor
//         self.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        
        self.setTitleColor(redColor, forState: UIControlState.Normal)
        self.setTitleColor(whiteColor, forState: UIControlState.Selected)
        // titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        layer.cornerRadius = 1.0
        
    }
    
}