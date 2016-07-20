//
//  APIManager.swift
//  APIManager-Alamofire
//
//  Created by Subramanian on 2/8/16.
//  Copyright © 2016 Subramanian. All rights reserved.
//

import Foundation
import Alamofire

typealias ResponseHandler = (Dictionary<String, AnyObject>?, NSError?) -> Void

class APIManager {
    
    // Class Stored Properties
    static let sharedInstance = APIManager()
    
    static let rootKey = "Root";
    
    // MARK: Methods
    // MARK: API Request
    func makeAPIRequest(apiObject: APIBase, completionHandler:ResponseHandler) {
        
        if apiObject.isMultipartRequest() == true  {
            var urlString = apiObject.urlForRequest()
            urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            Alamofire.upload(apiObject.requestType(), urlString, multipartFormData: { (multipartFormData) -> Void in
                apiObject.multipartData(multipartFormData)
                }) { (encodingResult) -> Void in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseData(){ [unowned self] response in
                            if let data = response.result.value {
                                self.serializeAPIResponse(apiObject, response: data, compleationHandler: completionHandler)
                            } else {
                                completionHandler(nil,nil)
                            }
                        }
                    case .Failure(_):
                        let error = NSError(domain: apiObject.urlForRequest(), code: 404, userInfo: nil)
                        completionHandler(nil,error)
                    }
            }
        } else {
            var urlString = apiObject.urlForRequest()
            urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            Alamofire.request(apiObject.requestType(),urlString,parameters:apiObject.requestParameter())
                .responseData() { [unowned self] response in
                    if let data = response.result.value {
                        self.serializeAPIResponse(apiObject, response: data, compleationHandler: completionHandler)
                    } else {
                        completionHandler(nil,nil)
                    }
            }
        }
        
    }
    
    
    // MARK: Response serializer
    func serializeAPIResponse(apiObject: APIBase, response: NSData?, compleationHandler:ResponseHandler) {
        if let data = response {
            do {
                // Check if it is Dictionary
                if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject> {
                    apiObject.parseAPIResponse(jsonDictionary)
                    compleationHandler(jsonDictionary, nil)
                }
            } catch {
                do {
                    // Check if it is Array of Dictionary/String
                    if let jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? Array<AnyObject> {
                        let jsonDictionary = [APIManager.rootKey : jsonArray]
                        apiObject.parseAPIResponse(jsonDictionary)
                        compleationHandler(jsonDictionary, nil)
                    }
                } catch let error as NSError {
                    compleationHandler(nil, error)
                } catch {
                    // Catch any other type of errors here.
                }
            }
        }
    }
}
