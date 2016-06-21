//
//  UIStoryboard.swift
//  MyMatchBox
//
//  Created by Vinothini on 5/31/16.
//  Copyright © 2016 Tarento Technologies. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func viewController(viewControllerId: String, storyBoardName: String) -> UIViewController? {
        if viewControllerId.isEmpty || storyBoardName.isEmpty {
            return nil
        }
        
        let storyBoard = UIStoryboard(name:storyBoardName , bundle: nil)
        let controller: UIViewController = storyBoard.instantiateViewControllerWithIdentifier(viewControllerId)
        return controller
    }
}
