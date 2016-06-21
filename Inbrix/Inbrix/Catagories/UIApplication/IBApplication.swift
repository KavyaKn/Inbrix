//
//  IBApplication.swift
//  Inbrix
//
//  Created by Kavya on 09/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

extension UIApplication {
    
    class func topViewController(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabBarController = viewController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presentedViewController = viewController?.presentedViewController {
            return topViewController(presentedViewController)
        }
        
        if let slideViewController = viewController as? SlideMenuController {
            return topViewController(slideViewController.mainViewController)
        }
        return viewController
    }
    
}
