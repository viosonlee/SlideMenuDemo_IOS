//
//  ContainerViewController.swift
//  SlideMenuDemo
//
//  Created by lifeng on 16/8/23.
//  Copyright © 2016年 lifeng. All rights reserved.
//

import UIKit
private extension UIStoryboard{
    class func mainStoryboard()->UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func leftMenuController()->LeftMenuViewController?{
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftMenu") as? LeftMenuViewController
    }
    
    class func rightMenuController()->RightMenuViewController?{
        return mainStoryboard().instantiateViewControllerWithIdentifier("RightMenu") as? RightMenuViewController
    }
    
    class func centerController()->CenterViewController?{
        return mainStoryboard().instantiateViewControllerWithIdentifier("Center") as? CenterViewController
    }
    
}



class ContainerViewController: UIViewController ,CenterViewControllerDelegate{
    
    var centerNavgationController: UINavigationController!
    var centerViewController:CenterViewController!
    var leftNavgationController: UINavigationController!
    var leftMenu:LeftMenuViewController?
    var rightNavgationController: UINavigationController!
    var rightMenu:RightMenuViewController?
    
    var centerPanelExpandedOffset: CGFloat = 100.0
    var statusBarHeight:CGFloat?
    var titleBarHeight:CGFloat?
    
    var currentState: SlideOutState!
    @IBAction func leftClick(sender: AnyObject) {
        self.toggleLeftPanel()
    }
    @IBAction func rightClick(sender: AnyObject) {
        self.toggleRightPanel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        
        centerViewController = UIStoryboard.centerController()
        
        centerNavgationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavgationController.view)
        addChildViewController(centerNavgationController)
        centerNavgationController.didMoveToParentViewController(self)
        //添加阴影
        centerNavgationController.view.layer.shadowOpacity = 0.5
        centerNavgationController.view.layer.shadowColor = UIColor.redColor().CGColor
        centerNavgationController.view.clipsToBounds = false //因为tablieview 的clips to bounds 默认等于 true， 如果不改过来，则添加的效果不会显示。
        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
//        centerNavgationController.view.addGestureRecognizer(panGestureRecognizer)
        
        centerViewController.setDelegate(self)
        
        currentState = SlideOutState.BothCollapsed
        
        statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        titleBarHeight = centerNavgationController?.navigationBar.frame.height
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var leftMenuIsClosed = true
    var rightMenuIsClosed = true
    
    func toggleLeftPanel() {
        if currentState == SlideOutState.BothCollapsed {
            addLeftMenu()
            animateLeftMenu(true)
        }else if currentState == SlideOutState.LeftPanelExpanded{
            
            animateLeftMenu(false)
        }else{
            animateRightPanel(false)
            
        }
    }
    func toggleRightPanel() {
        if currentState == SlideOutState.BothCollapsed {
            addRightMenu()
            animateRightPanel(true)
        }else if currentState == SlideOutState.RightPanelExpanded{
            
            animateRightPanel(false)
        }else{
            animateLeftMenu(false)
        }
        
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer){
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x>0)
        
        switch (recognizer.state) {
        case .Began:
            if (currentState == SlideOutState.BothCollapsed) {
                if gestureIsDraggingFromLeftToRight {
                    
                    addLeftMenu()
                    
                }else{
                    
                    addRightMenu()
                }
            }
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
            
            recognizer.setTranslation(CGPointZero, inView: view)
            
        case .Ended:
            if leftNavgationController != nil {
                
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                
                animateLeftMenu(hasMovedGreaterThanHalfway)
                
            }else
            
                if(rightNavgationController != nil){
                
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x < 0
                
                animateRightPanel(hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
        
    }
    
    func addLeftMenu(){
        leftMenu = UIStoryboard.leftMenuController()
        leftNavgationController = UINavigationController(rootViewController: leftMenu!)
        //        view.insertSubview(leftNavgationController.view, atIndex: 0)
        view.addSubview(leftNavgationController.view)
        
        addChildViewController(leftNavgationController)
        
        leftNavgationController.didMoveToParentViewController(self)
        
        leftNavgationController.view.layer.shadowOpacity = 0.5
        leftNavgationController.view.layer.shadowColor = UIColor.redColor().CGColor
        leftNavgationController.view.clipsToBounds = false
        
        leftNavgationController?.view.frame.size.width = self.view.bounds.width - centerPanelExpandedOffset+20
        leftNavgationController?.view.center.x = -((leftNavgationController?.view.frame.size.width)!)/2
        
        
    }
    
    func addRightMenu(){
        rightMenu = UIStoryboard.rightMenuController()
        rightNavgationController = UINavigationController(rootViewController: rightMenu!)
        view.insertSubview(rightNavgationController.view, atIndex:0)
        //        view.insertSubview(rightMenu!.view!, atIndex: 0)
        addChildViewController(rightNavgationController)
        //        addChildViewController(rightMenu!)
        rightNavgationController.didMoveToParentViewController(self)
        //        rightMenu?.didMoveToParentViewController(self)
        
        rightNavgationController.view.frame.size.width = self.view.bounds.width - centerPanelExpandedOffset+20
        
        //        rightMenu?.view.frame.size.width = self.view.bounds.width - centerPanelExpandedOffset+20
        rightNavgationController?.view.center.x = self.view.bounds.width/2 + centerPanelExpandedOffset/2
        //        rightMenu?.view.center.y = self.view.bounds.height/2 + self.statusBarHeight! + self.titleBarHeight!
    }
    
    func animateLeftMenu(shouldExpand: Bool){
        if shouldExpand {
            
            currentState = SlideOutState.LeftPanelExpanded
            //            animateCenterXPosition(CGRectGetWidth(centerViewController.view.frame) - centerPanelExpandedOffset)
            
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                
                self.leftNavgationController?.view.center.x = (self.leftNavgationController?.view.frame.size.width)!/2
                
                }, completion: nil)
            
        }else{
            
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                
                self.leftNavgationController?.view.center.x = -((self.leftNavgationController?.view.frame.size.width)!)/2
                
                }, completion: { finished in
                    self.currentState = SlideOutState.BothCollapsed
                    
                    self.leftNavgationController!.view.removeFromSuperview()
                    
                    self.leftNavgationController = nil
                    
            })
            
            
            //
            //            animateCenterXPosition(0){finished in
            //                self.currentState = SlideOutState.BothCollapsed
            //
            //                self.leftNavgationController!.view.removeFromSuperview()
            //
            //                self.leftNavgationController = nil
            //            }
            
        }
        
        
    }
    
    func animateRightPanel(shouldExpand: Bool){
        if shouldExpand {
            
            currentState = SlideOutState.RightPanelExpanded
            animateCenterXPosition(centerPanelExpandedOffset - CGRectGetWidth(centerViewController.view.frame))
        }else{
            animateCenterXPosition(0){finished in
                self.currentState = SlideOutState.BothCollapsed
                
                self.rightNavgationController?.view.removeFromSuperview()
                
                self.rightNavgationController = nil
            }
            
        }
        
    }
    
    func animateCenterXPosition(targetPosition: CGFloat,completion: ((Bool) -> Void)! = nil){
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavgationController.view.frame.origin.x = targetPosition
            }, completion: completion)
        
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
