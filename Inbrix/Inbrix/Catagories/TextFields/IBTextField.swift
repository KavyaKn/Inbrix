//
//  IBTextField.swift
//  Inbrix
//
//  Created by Kavya on 28/03/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation

import UIKit

extension UITextField {
    
    func configureTextField() {
        
        self.backgroundColor = UIColor.clearColor()
        self.leftViewMode = UITextFieldViewMode.Always
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, self.layer.frame.size.height - 1, self.layer.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        self.layer.addSublayer(bottomBorder)
        self.tintColor = UIColor.lightGrayColor()
    }
    
    func configureUserNameTextField() {
        self.configureTextField()
        self.leftView = self.setPlaceholderImageView("user")
        self.attributedPlaceholder = NSAttributedString(string:String.localizedValueForKey("UserNamePlaceHolderText"),
                                                                          attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    }
    
    func configurePasswordTextField() {
        
        self.configureTextField()
        self.leftView = self.setPlaceholderImageView("lock")
        self.attributedPlaceholder = NSAttributedString(string:String.localizedValueForKey("PasswordPlaceHolderText"),
                                                        attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
    }
    
    func setPlaceholderImageView(imageName: String) -> UIImageView {
        
        let imageView: UIImageView = UIImageView(image: UIImage(named: imageName))
        imageView.frame = CGRectMake(0.0, 0.0, imageView.image!.size.width + 20.0, imageView.image!.size.height)
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }
    
}
