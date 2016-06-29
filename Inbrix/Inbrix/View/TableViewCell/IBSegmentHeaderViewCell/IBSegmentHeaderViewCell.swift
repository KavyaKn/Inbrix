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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customHeaderView(){
        let normalTitleAttributesDictionary: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.orangeColor(),
            NSFontAttributeName : UIFont.cellLabelFont()
        ]
        
        let selectedTitleAttributesDictionary: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont.cellLabelFont()
        ]
        
        segmentedControl.setTitleTextAttributes(normalTitleAttributesDictionary, forState: .Normal)
        segmentedControl.setTitleTextAttributes(selectedTitleAttributesDictionary, forState: .Selected)
        segmentedControl.tintColor = UIColor.whiteColor()
        segmentedControl.backgroundColor = UIColor.segmentedControlBackgroundColor()
        segmentedControl.layer.cornerRadius = 0.0
        segmentedControl.layer.borderColor = UIColor.segmentedControlBorderColor().CGColor
        segmentedControl.layer.borderWidth = 1
    }
    
}
