//
//  IBPlaceListapi.swift
//  Inbrix
//
//  Created by Kavya on 14/07/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import Alamofire

class IBPlaceListapi: APIBase {
    
    var nearByPlaceListArray = [IBLocationModel]()
    // MARK: URL
    override func urlForRequest() -> String {
        return "\(APIConfig.BaseURL)/5787674f0f00003a26a585a3"
    }
    
    // MARK: HTTP method type
    override func requestType() -> Alamofire.Method {
        return Alamofire.Method.GET
    }
    
    // MARK: API parameters
    override func requestParameter() -> Dictionary<String, AnyObject>? {
        return [:]
    }
    
    // MARK: Response parser
    override func parseAPIResponse(response: Dictionary<String, AnyObject>?) {
        print("\(response)")
        let loactionArray = response!["Root"] as! [AnyObject]
        for (_, item) in loactionArray.enumerate() {
            let placeDictionary = item as! Dictionary<String, String>
            let placeModel = IBLocationModel.initializeWithDictionary(placeDictionary)
            self.nearByPlaceListArray.append(placeModel)
        }
    }
    
    // MARK: Is Multipart Request
    override func isMultipartRequest() -> Bool {
        return false
    }
    
    // MARK: MultipartData
    override func multipartData(multipartData : MultipartFormData?) {
        
    }


}
