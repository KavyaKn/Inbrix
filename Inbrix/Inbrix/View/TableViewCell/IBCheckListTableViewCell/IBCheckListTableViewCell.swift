//
//  IBCheckListTableViewCell.swift
//  Inbrix
//
//  Created by Kavya on 07/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBCheckListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkListButton: CheckBox!
    @IBOutlet weak var checkListLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.checkListButton.tintColor = UIColor.orangeColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
