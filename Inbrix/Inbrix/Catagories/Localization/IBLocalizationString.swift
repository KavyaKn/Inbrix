//
//  IBLocalizationString.swift
//  Inbrix
//
//  Created by Kavya on 26/04/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import Foundation

extension String {
    
    static func localizedValueForKey(key : String) -> String {
        let value: String = NSLocalizedString(key, comment: key)
        return value
    }
    
}
