//
//  IBImageCollectionViewCell.swift
//  InbrixImageSample
//
//  Created by Kavya on 12/04/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImageView: UIImageView!
    
    override func awakeFromNib() {
        self.initializeView()
    }
    
    func initializeView(){
        self.collectionImageView.layer.borderWidth = 1.0
        self.collectionImageView.layer.masksToBounds = false
        self.collectionImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.collectionImageView.layer.cornerRadius = self.collectionImageView.frame.size.width/2
        self.collectionImageView.clipsToBounds = true
    }
}
