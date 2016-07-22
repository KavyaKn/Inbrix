//
//  IBBaseVC.swift
//  Inbrix
//
//  Created by Kavya on 08/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBBaseVC: UIViewController, UIAlertViewDelegate {

    // Add custom back button
    
    func addCustomBackButton() {
        let backBtn: UIButton = UIButton(type: .Custom)
        let backBtnImage: UIImage = UIImage(named:kIBBackButtonImageName)!
        backBtn.setBackgroundImage(backBtnImage, forState: .Normal)
        backBtn.addTarget(self, action: #selector(IBBaseVC.backButtonClicked(_:)), forControlEvents: .TouchUpInside)
        backBtn.frame = CGRectMake(0, 0, 16, 16)
        let backButton: UIBarButtonItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func addLeftMenuBarMenuButtonItem() {
        self.addLeftBarButtonWithImage(UIImage(named: kIBMenuButtonImageName)!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    func backButtonClicked(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // Alert view methods
    
    func showAlertWithTitle(title: String, message messageString: String) {
        
        let myAlert: UIAlertController = UIAlertController(title: title, message: messageString, preferredStyle: .Alert)
//        myAlert.addAction(UIAlertAction(title:String.localizedValueForKey("AlertOkButtonTitle"), style: .Default, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func showAlertWithTitle(title: String, message messageString: String, delegate: AnyObject, tag: Int, cancelButtonTitle cancelTitle: String, otherButtonTitle otherTitle: String) {
        
        let myAlertView: UIAlertController = UIAlertController(title: title, message: messageString, preferredStyle: .Alert)
//        myAlertView.addAction(UIAlertAction(title:String.localizedValueForKey("AlertOkButtonTitle"), style: .Default, handler: nil))
        self.presentViewController(myAlertView, animated: true, completion: nil)
    }
    
    func endViewEditing() {
        self.view!.endEditing(true)
    }


}
