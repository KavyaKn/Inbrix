//
//  IBMenuHeaderView.swift
//  Inbrix
//
//  Created by Kavya on 09/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBMenuHeaderView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func initializeView() {
//        nameLabel.backgroundColor = UIColor.menuHeaderLabelBackgroundColor()
        nameLabel.textColor = UIColor.menuHeaderLabelColor()
        nameLabel.font = UIFont.cellLabelFont()
    }

}
