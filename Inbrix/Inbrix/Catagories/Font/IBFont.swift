//
//  IBFont.swift
//  Inbrix
//
//  Created by Kavya on 09/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation
import UIKit

let kIBNormalFontName = "HelveticaNeue"
let kIBBoldFontName = "HelveticaNeue-Bold"
let kIBMediumBoldFontName = "HelveticaNeue-Medium"
let kIBThinFontName = "HelveticaNeue-Thin"
let kIBLightFontName = "HelveticaNeue-Light"

extension UIFont {
    
    // MARK: - Menu screen fonts..
    
    class func menuCellLabelFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 15)!
    }
    
    class func cellLabelFont() -> UIFont {
        return UIFont(name: kIBLightFontName, size: 15)!
    }
    
    class func cellPlaceholderLabelFont() -> UIFont {
        return UIFont(name: kIBBoldFontName, size: 15)!
    }
    
    class func segmentLabelFont() -> UIFont {
        return UIFont(name: kIBLightFontName, size: 12)!
    }
    
    class func menuHeaderLabelFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 20)!
    }
    
    // MARK: - Login and register screen fonts..
    
    class func defaultTextFieldFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 15)!
    }
    
    class func defaultButtonFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 15)!
    }
    
    class func forgotPasswordButtonFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 15)!
    }
    
    class func doNotHaveAccountButtonFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 15)!
    }
    
    class func socialLoginButtonFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 15)!
    }
    
    class func defaultLabelFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 15)!
    }
    
    // MARK: - Search screen fonts..
    
    class func searchScreenButtonTextFont() -> UIFont {
        return UIFont(name: kIBNormalFontName, size: 15)!
    }
    
    class func searchScreenLabelTextFont() -> UIFont {
        return UIFont(name: kIBBoldFontName, size: 15)!
    }
    
    class func searchButtonFont() -> UIFont {
        return UIFont(name: kIBBoldFontName, size: 15)!
    }
    
    
}
