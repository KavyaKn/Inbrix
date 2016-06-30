//
//  IBEstablishmentCell.swift
//  Inbrix
//
//  Created by Kavya on 30/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBEstablishmentCell: UITableViewCell {

    @IBOutlet weak var establishmentCellLabel: UILabel!
    @IBOutlet weak var establishmentCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.establishmentCellView.layer.cornerRadius = 2
        self.establishmentCellView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
