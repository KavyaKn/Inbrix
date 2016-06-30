//
//  IBSegmentHeaderViewCell.swift
//  Inbrix
//
//  Created by Kavya on 10/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBSegmentHeaderViewCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.segmentedControl.customSegmentView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
