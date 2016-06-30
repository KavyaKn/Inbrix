//
//  IBSegmentedControl.swift
//  Inbrix
//
//  Created by Kavya on 30/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    
    func customSegmentView(){
        let normalTitleAttributesDictionary: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.orangeColor(),
            NSFontAttributeName : UIFont.cellLabelFont()
        ]
        
        let selectedTitleAttributesDictionary: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont.cellLabelFont()
        ]
        
        self.setTitleTextAttributes(normalTitleAttributesDictionary, forState: .Normal)
        self.setTitleTextAttributes(selectedTitleAttributesDictionary, forState: .Selected)
        self.tintColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.segmentedControlBackgroundColor()
        self.layer.cornerRadius = 0.0
        self.layer.borderColor = UIColor.segmentedControlBorderColor().CGColor
        self.layer.borderWidth = 1
    }
    
}
