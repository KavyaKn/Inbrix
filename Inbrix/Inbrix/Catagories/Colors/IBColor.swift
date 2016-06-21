//
//  IBColor.swift
//  Inbrix
//
//  Created by Kavya on 09/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        self.init(hexString: hexString, alpha:1)
    }
    
    convenience init(hexString: String, alpha: CGFloat) {
        var hexWithoutSymbol = hexString
        if hexWithoutSymbol.hasPrefix("#") {
            let index = hexString.startIndex.advancedBy(1)
            hexWithoutSymbol = hexString.substringFromIndex(index)
        }
        
        let scanner = NSScanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.characters.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(red: (CGFloat(r)/255),
                  green: (CGFloat(g)/255),
                  blue: (CGFloat(b)/255),
                  alpha:alpha)
    }
    
    // MARK: - Menu screen colors..
    
    class func menuCellTintColor() -> UIColor {
        return UIColor.blackColor()
    }
    
    class func menuCellSelectedTintColor() -> UIColor {
        return UIColor.redColor()
    }
    
    class func menuHeaderLabelColor() -> UIColor {
        return UIColor.grayColor()
    }
    
    class func menuHeaderLabelBackgroundColor() -> UIColor {
        return UIColor.blackColor().colorWithAlphaComponent(0.1)
    }
    
    // MARK: - Login and register screen colors..
    
    class func defaultAppTextFiledTintColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func defaultAppButtonBackgroundColor() -> UIColor {
        return UIColor(hexString: "#CA081F")
    }
    
    class func defaultAppButtonTintColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func defaultAppLabelTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func defaultNavigationBarTintColor() -> UIColor {
        return UIColor(hexString: "#FF7F00")
    }
    
    class func defaultNavigationBarTitleColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func segmentedControlBorderColor() -> UIColor {
        return UIColor(hexString: "#EFEFEF")
    }
    
    class func segmentedControlBackgroundColor() -> UIColor {
        return UIColor(hexString: "#F7F0E3")
    }
    
    
    
}