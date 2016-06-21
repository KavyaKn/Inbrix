//
//  IBLabel.swift
//  Inbrix
//
//  Created by Kavya on 09/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func MB_defaultAppLabelUI(title: String) {
        self.tintColor = UIColor.defaultAppLabelTextColor()
        self.textColor = UIColor.defaultAppLabelTextColor()
        self.backgroundColor = UIColor.clearColor()
        self.textAlignment = NSTextAlignment.Center
        self.text = title
    }
}
