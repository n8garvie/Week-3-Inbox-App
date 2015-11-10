//
//  MailboxViewController.swift
//  Inbox
//
//  Created by Nathan Garvie on 11/4/15.
//  Copyright © 2015 Nathan. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var archiveIcon: UIView!
    @IBOutlet weak var deleteIconImage: UIImageView!
    @IBOutlet weak var archiveIconImage: UIImageView!
    @IBOutlet weak var snoozeIcon: UIView!
    @IBOutlet weak var laterIconImage: UIImageView!
    @IBOutlet weak var listIconImage: UIImageView!
    @IBOutlet weak var messageListImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    var messageOriginalCenter: CGPoint!
    var messageIsSnoozed: Bool!
    var messageIsArchived: Bool!
    
    var archiveIconOriginalCenter: CGPoint!
    var snoozeIconOriginalCenter: CGPoint!
    
    var contentViewOriginalCenter: CGPoint!
    var menuIsOpen: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = imageView.image!.size
        listView.alpha = 0
        rescheduleView.alpha = 0
        messageOriginalCenter = messageImageView.frame.origin
        messageView.backgroundColor = UIColor(hue: 123, saturation: 0, brightness: 88, alpha: 100)
        messageIsArchived = false
        messageIsSnoozed = false
        deleteIconImage.alpha = 0
        archiveIconImage.alpha = 0.5
        listIconImage.alpha = 0
        laterIconImage.alpha = 0.5
        archiveIconOriginalCenter = archiveIcon.center
        snoozeIconOriginalCenter = snoozeIcon.center
        contentViewOriginalCenter = contentView.frame.origin
        menuIsOpen = false
        
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMessageDrag:")
        
        messageImageView.addGestureRecognizer(panGestureRecognizer)
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
        
        
        // set background of message view to grey
        messageView.backgroundColor = UIColorFromRGB(0xE0E0E0)
        
        // Do any additional setup after loading the view.
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    // found this here: http://stackoverflow.com/questions/24074257/how-to-use-uicolorfromrgb-value-in-swift
    

    @IBAction func onMessageDrag(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        var point = panGestureRecognizer.locationInView(view)
        
        
        // Relative change in (x,y) coordinates from where gesture began.
        var translation = panGestureRecognizer.translationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)

        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began{
            print("pan began")
            messageOriginalCenter = messageImageView.center
            
        }else if panGestureRecognizer.state == UIGestureRecognizerState.Changed{
            print(translation.x)
            
            // move the message image view
            messageImageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            // change the colour of the background as the message is dragged
            if translation.x > 64 && translation.x < 160{
                self.messageIsArchived.boolValue == true
                print("this should be green")
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageView.backgroundColor = self.UIColorFromRGB(0x45DE4C)
                    self.archiveIconImage.alpha = 1
                })
                self.deleteIconImage.alpha = 0
                self.archiveIcon.center = CGPoint(x: archiveIconOriginalCenter.x + translation.x - 64, y: archiveIconOriginalCenter.y)
            } else if translation.x > 160{
                // the delete state
                self.messageView.backgroundColor = UIColorFromRGB(0xDE4444)
                archiveIconImage.alpha = 0
                deleteIconImage.alpha = 1
                self.archiveIcon.center = CGPoint(x: self.archiveIconOriginalCenter.x + translation.x - 64, y: self.archiveIconOriginalCenter.y)
                self.snoozeIcon.alpha = 0
                print("this should be red")
            } else if translation.x < 63 && translation.x > -63 {
                // if you drag the message back to its orig position reset the background to grey
                self.messageView.backgroundColor = self.UIColorFromRGB(0xE0E0E0)
                print("back to grey")
            } else if translation.x < -64  && translation.x > -160{
                // snooze later state
                messageIsSnoozed = true
                print("this should be snoozed")
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.messageView.backgroundColor = self.UIColorFromRGB(0xF2ED4B)
                    self.laterIconImage.alpha = 1
                })
                self.listIconImage.alpha = 0
                self.snoozeIcon.center = CGPoint(x: snoozeIconOriginalCenter.x + translation.x + 64, y: snoozeIconOriginalCenter.y)
            } else if translation.x < -160 {
                // the list state
                self.messageView.backgroundColor = UIColorFromRGB(0xBF913B)
                laterIconImage.alpha = 0
                listIconImage.alpha = 1
                self.snoozeIcon.center = CGPoint(x: self.snoozeIconOriginalCenter.x + translation.x + 64, y: self.snoozeIconOriginalCenter.y)
            }
            
            
        }else if panGestureRecognizer.state == UIGestureRecognizerState.Ended{
            print("pan ended")
            //var velocity = panGestureRecognizer.velocityInView(view)
            
            //decide where to snap the message & what to show on release
            if velocity.x > 0 && translation.x > 64{
                print("snap dat archive")
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.archiveIcon.alpha = 0
                    self.messageImageView.frame.origin.x = 750
                    UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                        self.messageView.alpha = 0
                        self.messageListImage.frame.origin.y = 75
                        }, completion: { (Bool) -> Void in})
                })
            } else if messageIsArchived == false && messageIsSnoozed == false{
                //snap back to original position
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageImageView.frame.origin.x = 0
                })
            } else if translation.x < -64 && translation.x > -160 {
                print("snap dat snooze")
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageImageView.frame.origin.x = -568
                    self.rescheduleView.alpha = 1
                    self.archiveIcon.alpha = 0
                    self.snoozeIcon.alpha = 0
                })
            } else if translation.x < -160{
                print("snap dat list")
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageImageView.frame.origin.x = -568
                    self.listView.alpha = 1
                    self.archiveIcon.alpha = 0
                    self.snoozeIcon.alpha = 0
                })
            }
        }
    }
    
    //dismiss the snooze views
    @IBAction func didTapView(sender: AnyObject) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.rescheduleView.alpha = 0
            self.messageView.alpha = 0
            UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                self.messageListImage.frame.origin.y = 75
                
                }, completion: { (Bool) -> Void in})
        }
    }
    
    //dismiss the list view
    @IBAction func didTapListView(sender: AnyObject) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.listView.alpha = 0
             self.messageView.alpha = 0
            UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                self.messageListImage.frame.origin.y = 75
               
                }, completion: { (Bool) -> Void in})
        }
    }
    
    
    
    // pan from edge to reveal menu
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        
        var point = sender.locationInView(view)
        
        
        // Relative change in (x,y) coordinates from where gesture began.
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            print("edge panning began")
            print(velocity.x)

        } else if sender.state == UIGestureRecognizerState.Changed {
            //moving the contentView on swipe
            contentView.frame.origin = CGPoint(x: contentViewOriginalCenter.x + translation.x, y: contentViewOriginalCenter.y)
            
            if velocity.x > 0 {
                menuIsOpen == true
                print("menu is open", velocity.x)
                
            } else if velocity.x < 0 {
                print("menu is closed", velocity.x)
                menuIsOpen == false
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended{
            if translation.x > 100 && velocity.x > 0 {
                print("snap open")
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.contentView.frame.origin.x = 276
                })
            } else if translation.x < 100 && velocity.x < 0{
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.contentView.frame.origin.x = self.contentViewOriginalCenter.x
                })
            }
        }


    }
    @IBAction func onMenuButtonTap(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.contentView.frame.origin.x = self.contentViewOriginalCenter.x
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
