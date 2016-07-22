//
//  IBCollectionViewCell.swift
//  Inbrix
//
//  Created by Kavya on 22/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit

typealias DeleteButtonCallBack = (sender: UIButton) -> Void

class IBCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteCallBack: DeleteButtonCallBack?
    
    
    override var selected: Bool {
        didSet {
            if(selected){
                self.collectionImageView.layer.borderColor = UIColor(red: CGFloat(0.26), green: CGFloat(0.26), blue: CGFloat(0.26), alpha: CGFloat(1.0)).CGColor
                self.collectionImageView.layer.borderWidth = 3.0
            }else{
                self.collectionImageView.layer.borderColor = UIColor.clearColor().CGColor
                self.collectionImageView.layer.borderWidth = 0.0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    func initializeView() {
        textLabel.textColor = UIColor.whiteColor()
        textLabel.text = "+"
        textLabel.textAlignment = .Center
        self.textLabel.layer.borderWidth = 2.0
        self.textLabel.layer.borderColor = UIColor(red: CGFloat(0.26), green: CGFloat(0.26), blue: CGFloat(0.26), alpha: CGFloat(1.0)).CGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func styleImage () {
        textLabel.hidden = true
        deleteButton.hidden = false
    }
    
    internal func styleAddButton() {
        textLabel.hidden = false
        deleteButton.hidden = true
    }

    @IBAction func deleteButtonClicked(sender: AnyObject) {
        if deleteCallBack != nil {
            deleteCallBack!(sender: sender as! UIButton)
        }
    }
}
