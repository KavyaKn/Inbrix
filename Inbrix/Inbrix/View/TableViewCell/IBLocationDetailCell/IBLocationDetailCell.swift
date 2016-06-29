//
//  IBLocationDetailCell.swift
//  Inbrix
//
//  Created by Kavya on 29/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBLocationDetailCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationIdLabel: UILabel!
    @IBOutlet weak var loactionPhoneNoLabel: UILabel!
    @IBOutlet weak var locationEmailLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
