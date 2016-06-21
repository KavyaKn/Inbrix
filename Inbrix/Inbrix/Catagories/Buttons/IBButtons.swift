//
//  IBButtons.swift
//  Inbrix
//
//  Created by Kavya on 28/03/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation

import UIKit


extension UIButton {
    
    func configureButton() {
        self.layer.cornerRadius = 10.0;
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.clearColor()
        self.titleLabel?.textColor = UIColor.lightGrayColor()
        self.tintColor = UIColor.lightGrayColor()
    }
    
}


