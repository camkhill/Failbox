//
//  MailboxViewController.swift
//  Failbox
//
//  Created by Hill, Cameron on 8/30/16.
//  Copyright © 2016 Hill, Cameron. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navImage: UIImageView!
    @IBOutlet weak var helpImage: UIImageView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var topMessageView: UIView!
    //checkImage is actually the little clock
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var archiveImage: UIImageView!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet weak var listDismissButton: UIButton!
    @IBOutlet weak var rescheduleDismissButton: UIButton!
    @IBOutlet var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var menuImage: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    let messageOffset: CGFloat = CGFloat(200)
    var checkOriginalCenter: CGPoint!
    var archiveOriginalCenter: CGPoint!
    var feedOriginalCenter: CGPoint!
    var menuOriginalCenter: CGPoint!
    var edgeGesture: UIScreenEdgePanGestureRecognizer!

    //This var will be used to track what the most recent action was:
    // 0: no action taken yet
    // 1: deleted
    // 2: archived
    // 3: alarm set
    // 4: list
    var lastAction = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let totalHeight : CGFloat = navImage.frame.size.height + helpImage.frame.size.height + searchImage.frame.size.height + messageImage.frame.size.height + feedImage.frame.size.height
        let width : CGFloat = CGFloat(320)
        
        scrollView.contentSize = CGSize(width: width, height: totalHeight)
        checkImage.alpha = 1
        archiveImage.alpha = 1
        rescheduleImage.alpha = 0
        listImage.alpha = 0
        listDismissButton.enabled = false
        rescheduleDismissButton.enabled = false

        // Set up edge pan gesture recognizer
        edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgeGesture)
        
        // Set up and disable pan gesture recognizer on the menu

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTapReschedule(sender: AnyObject) {
        rescheduleDismissButton.enabled = false
        UIView.animateWithDuration(0.2, animations: { 
            self.rescheduleImage.alpha = 0
        
            }) { (Bool) in
                self.onReturnToInbox()
        }
    }
    
    @IBAction func onTapList(sender: AnyObject) {
        listDismissButton.enabled = false
        UIView.animateWithDuration(0.2, animations: { 
            self.listImage.alpha = 0
            }) { (Bool) in
                self.onReturnToInbox()
        }
        
    }
    
    

    @IBAction func onPanMessage(sender: UIPanGestureRecognizer) {
        
        let transform = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began{
            messageOriginalCenter = messageImage.center
            checkOriginalCenter = checkImage.center
            archiveOriginalCenter = archiveImage.center
            
        } else if sender.state == UIGestureRecognizerState.Changed{
            
            messageImage.center = CGPoint(x: messageOriginalCenter.x + transform.x, y: messageOriginalCenter.y)
            
            // Color ranges:
            // -60 : 60 = grey
            // -260 : -60 = yellow
            // < -260 = brown
            // 60 : 260 = green
            // > 260 = red
            
            
            if transform.x > 260 {
                self.topMessageView.backgroundColor = UIColor(red: 1, green: 0.352, blue: 0.352, alpha: 1)
                archiveImage.image = UIImage(named: "delete_icon")
                archiveImage.center = CGPoint(x: archiveOriginalCenter.x + transform.x - 60, y: archiveOriginalCenter.y)
                checkImage.alpha = 0
                archiveImage.alpha = 1
            } else if 60 < transform.x && transform.x <= 260 {
                self.topMessageView.backgroundColor = UIColor(red: 0.168, green: 0.908, blue: 0.399, alpha: 1)
                archiveImage.center = CGPoint(x: archiveOriginalCenter.x + transform.x - 60, y: archiveOriginalCenter.y)
                checkImage.alpha = 0
                archiveImage.alpha = 1
            } else if -60 < transform.x && transform.x <= 60 {
                self.topMessageView.backgroundColor = UIColor(red: 0.762, green: 0.762, blue: 0.762, alpha: 1)
                
                //adjust opacity based on offset amount
                if transform.x > 0 {
                    checkImage.alpha = transform.x/60
                    archiveImage.alpha = 0
                } else if transform.x < 0 {
                    
                    let alpha = -(transform.x/60)
                    checkImage.alpha = alpha
                    archiveImage.alpha = alpha
                }
                
                archiveImage.alpha = transform.x/60
            } else if -260 < transform.x && transform.x <= -60 {
                self.topMessageView.backgroundColor = UIColor(red: 0.994, green: 0.945, blue: 0.432, alpha: 1)
                checkImage.center = CGPoint(x: checkOriginalCenter.x + transform.x + 60, y: checkOriginalCenter.y)
                archiveImage.alpha = 0
                checkImage.alpha = 1
            } else if transform.x <= -260 {
                self.topMessageView.backgroundColor = UIColor(red: 0.645, green: 0.392, blue: 0, alpha: 1)
                checkImage.image = UIImage(named: "list_icon")
                checkImage.center = CGPoint(x: checkOriginalCenter.x+transform.x+60, y: checkOriginalCenter.y)
                archiveImage.alpha = 0
                checkImage.alpha = 1
            }
            
            
        } else if sender.state == UIGestureRecognizerState.Ended{
            
            if transform.x > 260 {
                //fly off right and delete
                lastAction = 1
                UIView.animateWithDuration(0.4, animations: {
                    self.archiveImage.alpha = 0
                    self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x + 370, y: self.messageOriginalCenter.y)
                    }, completion: { (Bool) in
                        //Delete message
                        self.onReturnToInbox()
                        
                })

            } else if 60 < transform.x && transform.x <= 260 {
                //fly off right and archive?
                lastAction = 2
                UIView.animateWithDuration(0.4, animations: {
                    self.archiveImage.alpha = 0
                    self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x + 370, y: self.messageOriginalCenter.y)
                    }, completion: { (Bool) in
                        //Slide up feed
                        self.onReturnToInbox()
                
                })
            } else if -60 < transform.x && transform.x <= 60 {
                //snap to center
                UIView.animateWithDuration(0.3, animations: {
                    self.messageImage.center = self.messageOriginalCenter
                })
            } else if -260 < transform.x && transform.x <= -60 {
                //fly off left and alarm
                lastAction = 3
                UIView.animateWithDuration(0.4, animations: {
                    self.checkImage.alpha = 0
                    self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x - 370, y: self.messageOriginalCenter.y)
                    }, completion: { (Bool) in
                        //Show Alerts
                        UIView.animateWithDuration(0.2, animations: { 
                            self.rescheduleImage.alpha = 1
                            self.rescheduleDismissButton.enabled = true
                        })
                        
                        
                        //self.resetMessageParams()


                        
                })
                
            } else if transform.x <= -260 {
                //fly off left and ??
                lastAction = 4
                UIView.animateWithDuration(0.4, animations: {
                    self.checkImage.alpha = 0
                    self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x - 370, y: self.messageOriginalCenter.y)
                    }, completion: { (Bool) in
                        //Show list
                        
                        UIView.animateWithDuration(0.2, animations: { 
                            self.listImage.alpha = 1
                            self.listDismissButton.enabled = true
                        })
                        
                        
                        //self.resetMessageParams()

                })
            }
            
            
        }
        
    }
    
    
    //Simple function to reset the message position and images
    func resetMessageParams() {
        self.messageImage.center = self.messageOriginalCenter
        self.checkImage.center = self.checkOriginalCenter
        self.archiveImage.center = self.archiveOriginalCenter
        archiveImage.image = UIImage(named: "archive_icon")
        checkImage.image = UIImage(named: "later_icon")
        self.feedImage.center = self.feedOriginalCenter
        
    }
    
    
    func onReturnToInbox() {
        
        let height = messageImage.frame.size.height
        feedOriginalCenter = feedImage.center
        UIView.animateWithDuration(0.3, animations: { 
            self.feedImage.center = CGPoint(x: self.feedOriginalCenter.x, y: self.feedOriginalCenter.y - height)
            
            }) { (Bool) in
                self.resetMessageParams()
                // Should i animate this?
                //UIView.animateWithDuration(0.5, animations: {
                //    self.feedImage.center = self.feedOriginalCenter
                //    self.resetMessageParams()
                //})
                
        }
        
        
    }
    
    
    
    @IBAction func onLeftEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began{
            menuOriginalCenter = menuImage.center
            
        } else if sender.state == UIGestureRecognizerState.Changed{
            menuImage.center = CGPoint(x: menuOriginalCenter.x + translation.x, y: menuOriginalCenter.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended{
            
            if velocity.x > 0 {
                sender.enabled = false
                UIView.animateWithDuration(0.5, animations: { 
                    self.menuImage.center.x = self.menuOriginalCenter.x + CGFloat(320)
                    }, completion: { (Bool) in
                        
                        //build a pan gesture recognizer and attach it to the menu
                        var menuPanGesture = UIPanGestureRecognizer(target: self, action: "onMenuPan:")
                        self.menuImage.addGestureRecognizer(menuPanGesture)
                        //enable pangesturerecognizer on the menu
                })
                
            } else if velocity.x <= 0 {
                UIView.animateWithDuration(0.5, animations: {
                    self.menuImage.center.x = self.menuOriginalCenter.x
                    
                })
            }
            
        }
    }
    
    func onMenuPan(sender: UIPanGestureRecognizer) {
        //set up motion control
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began{
            menuOriginalCenter = menuImage.center
        } else if sender.state == UIGestureRecognizerState.Changed{
            
            if translation.x >= 0 {
                menuImage.center.x = menuOriginalCenter.x
            } else if translation.x < 0 {
                menuImage.center.x = menuOriginalCenter.x + translation.x
            }
            
            
        } else if sender.state == UIGestureRecognizerState.Ended{
            if velocity.x < 0 {
                UIView.animateWithDuration(0.3, animations: {
                    self.menuImage.center.x = self.menuOriginalCenter.x - 320
                    }, completion: { (Bool) in
                        self.edgeGesture.enabled = true
                        
                })
                
                
            } else if velocity.x >= 0 {
                UIView.animateWithDuration(0.3, animations: {
                    self.menuImage.center.x = self.menuOriginalCenter.x
                    }, completion: { (Bool) in
                        //Do nothing
                })
                
            }
            
        }
        
        
        
    }
    
    
    @IBAction func onSelectorChanged(sender: UISegmentedControl) {
        
        
    }
    
    
    //Shake gesture code
    
    
    //Below is false by default, but needs to be true so view handles UIEvents
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        messageOriginalCenter = messageImage.center
        feedOriginalCenter = feedImage.center
        
        if lastAction == 0 {
            //do nothing if no recent action
        } else if lastAction == 1 {
            lastAction = 0
            let offset: CGFloat = 370
            undoAnimation(offset)
            
        } else if lastAction == 2 {
            lastAction = 0
            let offset: CGFloat = 370
            undoAnimation(offset)
            
        } else if lastAction == 3 {
            lastAction = 0
            let offset: CGFloat = -370
            undoAnimation(offset)
        } else if lastAction == 4 {
            lastAction = 0
            let offset: CGFloat = -370
            undoAnimation(offset)
        }
    }
    
    //This function does the animation to undo last action
    func undoAnimation(offset: CGFloat) {
        
        let height = messageImage.frame.size.height
        //move feed up to start
        feedImage.center = CGPoint(x: self.feedOriginalCenter.x, y: self.feedOriginalCenter.y - height)
        self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x + offset, y: self.messageOriginalCenter.y)
        
        UIView.animateWithDuration(0.3, animations: {
            self.feedImage.center = CGPoint(x: self.feedOriginalCenter.x, y: self.feedOriginalCenter.y)
            
        }) { (Bool) in
            
            UIView.animateWithDuration(0.3, animations: {
                self.messageImage.center = self.messageOriginalCenter
            })
            
        }
    }
    
}
