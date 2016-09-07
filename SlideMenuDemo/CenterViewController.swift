//
//  CenterViewController.swift
//  SlideMenuDemo
//
//  Created by lifeng on 16/8/23.
//  Copyright © 2016年 lifeng. All rights reserved.
//

import UIKit
protocol CenterViewControllerDelegate{
     func toggleLeftPanel()
     func toggleRightPanel()
}
class CenterViewController: UITableViewController {

    @IBAction func rightClick(sender: AnyObject) {
        delegate.toggleRightPanel()
    }
    @IBAction func leftClick(sender: AnyObject) {
        delegate.toggleLeftPanel()
    }
    
    var delegate: CenterViewControllerDelegate!
    
    func setDelegate(delegate: CenterViewControllerDelegate){
        self.delegate = delegate
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
