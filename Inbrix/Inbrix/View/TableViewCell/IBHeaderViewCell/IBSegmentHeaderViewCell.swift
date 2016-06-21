//
//  IBSegmentHeaderViewCell.swift
//  Inbrix
//
//  Created by Kavya on 10/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBSegmentHeaderViewCell: UITableViewCell {

    @IBOutlet weak var segmentedHeaderView: UISegmentedControl!
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
        
        segmentedHeaderView.setTitleTextAttributes(normalTitleAttributesDictionary, forState: .Normal)
        segmentedHeaderView.setTitleTextAttributes(selectedTitleAttributesDictionary, forState: .Selected)
        segmentedHeaderView.tintColor = UIColor.whiteColor()
        segmentedHeaderView.backgroundColor = UIColor.segmentedControlBackgroundColor()
        segmentedHeaderView.layer.cornerRadius = 0.0
        segmentedHeaderView.layer.borderColor = UIColor.segmentedControlBorderColor().CGColor
        segmentedHeaderView.layer.borderWidth = 1
    }
    
}
