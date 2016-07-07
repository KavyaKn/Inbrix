//
//  CheckBox.swift
//  CheckBox
//
//  Created by Kavya on 31/03/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    let checkedImage = UIImage(named: "Check")! as UIImage
    let unCheckedImage = UIImage(named: "Uncheck")! as UIImage
    
    //bool property
    var isChecked : Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(unCheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.button(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func button(sender:UIButton) {
        if(sender == self){
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
}
