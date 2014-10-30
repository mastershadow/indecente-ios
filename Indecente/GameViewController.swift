//
//  GameViewController.swift
//  Indecente
//
//  Created by Eduard Roccatello on 06/10/14.
//  Copyright (c) 2014 Roccatello Eduard. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController : UIViewController, UIAlertViewDelegate {
    struct Settings {
        var topMargin:Int = 20
        var leftMargin:Int = 20
        var xSpacing:Int = 20
        var ySpacing:Int = 10
        var xPills:Int = 0
        var yPills:Int = 0
        let width:Int = 31
        let height:Int = 71
        var pillsNumber:Int {
            return xPills * yPills
        }
        var poppedPills:Int = 0
    }
    
    struct Pill {
        let poppedImage: UIImage? = UIImage(named: "pill-off")
        let unpoppedImage: UIImage? = UIImage(named: "pill-on")
        
        var popped:Bool = false
        var image:UIImage {
            if popped {
                return poppedImage!
            }
            return unpoppedImage!
        }
    }
    
    var audioPlayer:FISoundEngine = FISoundEngine.sharedEngine() as FISoundEngine
    var popSound:FISound? = nil;
    //let popSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pop", ofType: "wav")!)
    var settings = Settings()
    var grid: [Pill] = []
    var gameLayer: CALayer = CALayer()
    var startDate: NSDate?
    
    override init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initGame() {
        startDate = NSDate()
        for var i = 0; i < grid.count; i++  {
            grid[i].popped = false
        }
        gameLayer.setNeedsDisplay()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
        UIGraphicsPushContext(ctx);
        // println("IDRIS")
        for var i = 0; i < grid.count; i++  {
            var ii = Int(i % settings.xPills)
            var jj = Int(i / settings.xPills)
            var xx = ii * (settings.width + settings.xSpacing) + settings.leftMargin
            var yy = jj * (settings.height + settings.ySpacing) + settings.topMargin

            grid[i].image.drawAtPoint(CGPoint(x: xx, y: yy))
        }
        UIGraphicsPopContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Diventa indecente";
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        var topBarH = self.navigationController!.navigationBar.frame.size.height
        var size = view.bounds.size
        
        size.height -= topBarH
        
        settings.xPills = Int((size.width + (CGFloat)(settings.xSpacing)) / CGFloat(settings.width + settings.xSpacing))
        settings.yPills = Int((size.height + (CGFloat)(settings.ySpacing)) / CGFloat(settings.height + settings.ySpacing))
        settings.leftMargin = (Int(size.width) - (settings.width + settings.xSpacing) * settings.xPills + settings.xSpacing) / 2
        settings.topMargin = (Int(size.height) - (settings.height + settings.ySpacing) * settings.yPills + settings.ySpacing) / 2
        settings.topMargin += Int(topBarH)
        
        for _ in 1...settings.pillsNumber {
            grid += [Pill()]
        }
        
        gameLayer.bounds = view.bounds
        gameLayer.position = CGPoint(x: gameLayer.bounds.size.width / 2, y: gameLayer.bounds.size.height / 2)
        gameLayer.delegate = self
        view.layer.addSublayer(gameLayer)
        
        var gesture = UITapGestureRecognizer(target: self, action: "onTap:")
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        
        var swipeBack = UISwipeGestureRecognizer(target: self, action: "onSwipeBack")
        swipeBack.numberOfTouchesRequired = 1
        swipeBack.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipeBack)
        /*
        audioPlayer = AVAudioPlayer(contentsOfURL: popSound, error: nil)
        audioPlayer?.numberOfLoops = 0;
        audioPlayer?.prepareToPlay()
        */
        popSound = audioPlayer.soundNamed("pop.wav", maxPolyphony: 4, error: nil)
//         NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("pop", ofType: "wav")!)
    }
    
    func onSwipeBack() {
        gameLayer.delegate = nil
        navigationController?.popViewControllerAnimated(true)
    }
    
    func onTap(gesture: UIGestureRecognizer) -> Void {
        var point = gesture.locationInView(view)
        point.x -= CGFloat(settings.leftMargin)
        point.y -= CGFloat(settings.topMargin)

        println(point)
        if point.x > 0 && point.y > 0 {
            var i:Int = Int(point.x / CGFloat(settings.width + settings.xSpacing))
            var j:Int = Int(point.y / CGFloat(settings.height + settings.ySpacing))

            // hit check
            if (point.x - CGFloat(i) * CGFloat(settings.width + settings.xSpacing)) > CGFloat(settings.width) {
                return;
            }
            if (point.y - CGFloat(j) * CGFloat(settings.height + settings.ySpacing)) > CGFloat(settings.height) {
                return;
            }
            if grid[j * settings.xPills + i].popped == false {
                grid[j * settings.xPills + i].popped = true
                settings.poppedPills++
                //play pop
                /*
                if audioPlayer?.playing == true {
                    audioPlayer!.stop()
                }
                audioPlayer!.play()
                */
                popSound!.play()
                gameLayer.setNeedsDisplay()
                // check
                if settings.pillsNumber == settings.poppedPills {
                    // finished
                    var endDate = NSDate()
                    var duration = endDate.timeIntervalSinceDate(startDate!)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var alert = UIAlertView()
                        alert.title = "Complimenti!"
                        alert.message = "Hai raggiunto l'indecenza in soli " + String(format: "%d", Int(duration)) + " secondi..."
                        alert.delegate = self
                        alert.addButtonWithTitle("Ok")
                        alert.show()
                    })
                }
            }
        }
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        initGame()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
        initGame()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        gameLayer.delegate = nil
        super.viewWillDisappear(animated);
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue);
    }
}
