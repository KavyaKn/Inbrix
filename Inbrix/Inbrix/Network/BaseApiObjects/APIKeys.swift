//
//  APIKeys.swift
//  APIManager-Alamofire
//
//  Created by Subramanian on 2/8/16.
//  Copyright © 2016 Subramanian. All rights reserved.
//

import Foundation

struct APIConfig {
    
    // Config
    static let isProduction: Bool = false
    
    static let ProductionURL: String = ""
    static let StagingURL: String = "http://www.mocky.io/v2"
    
    static var BaseURL: String {
        if isProduction  {
            return ProductionURL
        } else {
            return StagingURL
        }
    }
    
}


