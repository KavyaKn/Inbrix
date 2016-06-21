//
//  HeaderView.swift
//  AEAccordion
//
//  Created by Marko Tadic on 6/26/15.
//  Copyright © 2015 AE. All rights reserved.
//

import UIKit

class HeaderView: AEXibceptionView {
    
    // MARK: - Outlets
    @IBOutlet weak var locationLabel: UILabel!
    
    func customizeView(){
        self.locationLabel.font = UIFont.cellLabelFont()
    }
    
}
