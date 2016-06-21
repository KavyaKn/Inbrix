//
//  DetailView.swift
//  AEAccordion
//
//  Created by Marko Tadic on 6/26/15.
//  Copyright © 2015 AE. All rights reserved.
//

import UIKit

class DetailView: AEXibceptionView {

    // MARK: - Outlets
    
//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var namePlaceholderLabel: UILabel!
    @IBOutlet weak var idPlaceholderLabel: UILabel!
    @IBOutlet weak var emailPlaceholderLabel: UILabel!
    @IBOutlet weak var addressPlaceholderLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    
    func customizeCell(){
        self.nameLabel.font = UIFont.cellLabelFont()
        self.idLabel.font = UIFont.cellLabelFont()
        self.emailLabel.font = UIFont.cellLabelFont()
        self.addressLabel.font = UIFont.cellLabelFont()
        
        self.namePlaceholderLabel.font = UIFont.cellPlaceholderLabelFont()
        self.idPlaceholderLabel.font = UIFont.cellPlaceholderLabelFont()
        self.emailPlaceholderLabel.font = UIFont.cellPlaceholderLabelFont()
        self.addressPlaceholderLabel.font = UIFont.cellPlaceholderLabelFont()
    }
}
