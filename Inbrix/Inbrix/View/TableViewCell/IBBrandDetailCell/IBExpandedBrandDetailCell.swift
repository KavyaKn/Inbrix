//
//  IBExpandedBrandDetailCell.swift
//  Inbrix
//
//  Created by Kavya on 28/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

class IBExpandedBrandDetailCell: UITableViewCell {

    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandTitleLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeNumberLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    class var expandedHeight : CGFloat{ get { return 150} }
    class var defaultHeight : CGFloat{ get { return 40} }
    
    var frameAdded = false
    func checkHeight(){
        storeNameLabel.hidden = (frame.size.height < IBExpandedBrandDetailCell.expandedHeight)
        storeNumberLabel.hidden = (frame.size.height < IBExpandedBrandDetailCell.expandedHeight)
        storeAddressLabel.hidden = (frame.size.height < IBExpandedBrandDetailCell.expandedHeight)
        
    }
    
    func watchFrameChanges() {
        if(!frameAdded){
            addObserver(self , forKeyPath: "frame", options: .New, context: nil )
            frameAdded = true
        }
    }
    
    func ignoreFrameChanges() {
        if(frameAdded){
            removeObserver(self, forKeyPath: "frame")
            frameAdded = false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame"{
            checkHeight()
        }
    }
    deinit {
        print("deinit called");
        ignoreFrameChanges()
    }

    
    
    
}
