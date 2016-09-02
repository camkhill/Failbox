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
    
    var messageOriginalCenter: CGPoint!
    let messageOffset: CGFloat = CGFloat(200)
    var checkOriginalCenter: CGPoint!
    var archiveOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let totalHeight : CGFloat = navImage.frame.size.height + helpImage.frame.size.height + searchImage.frame.size.height + messageImage.frame.size.height + feedImage.frame.size.height
        let width : CGFloat = CGFloat(320)
        
        scrollView.contentSize = CGSize(width: width, height: totalHeight)
        checkImage.alpha = 1
        archiveImage.alpha = 1
        rescheduleImage.alpha = 0
        listImage.alpha = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            } else if 60 < transform.x && transform.x <= 260 {
                self.topMessageView.backgroundColor = UIColor(red: 0.168, green: 0.908, blue: 0.399, alpha: 1)
                archiveImage.center = CGPoint(x: archiveOriginalCenter.x + transform.x - 60, y: archiveOriginalCenter.y)
                checkImage.alpha = 0
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
            } else if transform.x <= -260 {
                self.topMessageView.backgroundColor = UIColor(red: 0.645, green: 0.392, blue: 0, alpha: 1)
                checkImage.image = UIImage(named: "list_icon")
                checkImage.center = CGPoint(x: checkOriginalCenter.x+transform.x+60, y: checkOriginalCenter.y)
                archiveImage.alpha = 0
            }
            
            
        } else if sender.state == UIGestureRecognizerState.Ended{
            
            if transform.x > 260 {
                //fly off right and delete
                UIView.animateWithDuration(0.4, animations: {
                    self.archiveImage.alpha = 0
                    self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x + 370, y: self.messageOriginalCenter.y)
                    }, completion: { (Bool) in
                        //Delete message
                        //temp just return everything
                        self.messageImage.center = self.messageOriginalCenter
                        self.checkImage.center = self.checkOriginalCenter
                        self.archiveImage.center = self.archiveOriginalCenter
                        
                })

            } else if 60 < transform.x && transform.x <= 260 {
                //fly off right and archive?
                UIView.animateWithDuration(0.4, animations: {
                    self.archiveImage.alpha = 0
                    self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x + 370, y: self.messageOriginalCenter.y)
                    }, completion: { (Bool) in
                        //Delete message
                        //temp just return everything
                        self.messageImage.center = self.messageOriginalCenter
                        self.checkImage.center = self.checkOriginalCenter
                        self.archiveImage.center = self.archiveOriginalCenter
                })
            } else if -60 < transform.x && transform.x <= 60 {
                //snap to center
                UIView.animateWithDuration(0.3, animations: {
                    self.messageImage.center = self.messageOriginalCenter
                })
            } else if -260 < transform.x && transform.x <= -60 {
                //fly off left and alarm
                UIView.animateWithDuration(0.4, animations: {
                    self.checkImage.alpha = 0
                    self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x - 370, y: self.messageOriginalCenter.y)
                    }, completion: { (Bool) in
                        //Show Alerts
                        UIView.animateWithDuration(0.2, animations: { 
                            self.rescheduleImage.alpha = 1
                        })
                        
                        //temp just return everything
                        self.messageImage.center = self.messageOriginalCenter
                        self.checkImage.center = self.checkOriginalCenter
                        self.archiveImage.center = self.archiveOriginalCenter
                        
                })
                
            } else if transform.x <= -260 {
                //fly off left and ??
                UIView.animateWithDuration(0.4, animations: {
                    self.checkImage.alpha = 0
                    self.messageImage.center = CGPoint(x: self.messageOriginalCenter.x - 370, y: self.messageOriginalCenter.y)
                    }, completion: { (Bool) in
                        //Show list
                        UIView.animateWithDuration(0.2, animations: { 
                            self.listImage.alpha = 1
                        })
                        
                        
                        //temp just return everything
                        self.messageImage.center = self.messageOriginalCenter
                        self.checkImage.center = self.checkOriginalCenter
                        self.archiveImage.center = self.archiveOriginalCenter
                })
            }
            
            
        }
        
    }
    
    
    
    
}
