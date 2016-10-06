//
//  APICommunication.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/04/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import Alamofire

protocol APICommunicationProtocol : class {
    var urlsManager: URLs { get }
    func sendRequestWithURL(url: URL,
                            requestType: HTTPMethod,
                            parameters: [String : AnyObject]?,
                            completion: @escaping CompletionBlock,
                            failure: @escaping FailureBlock)
}

typealias JSONObject = Any
typealias JSONDictionary = [String: JSONObject]
typealias CompletionBlock = (Any?) -> Void
typealias ProgressBlock = (Float) -> Void
typealias FailureBlock = (URLResponse?, Error?) -> Void

class APICommunication: APICommunicationProtocol {
    
    let urlsManager: URLs = URLs()
    
    func sendRequestWithURL(url: URL, requestType: HTTPMethod, parameters: [String : AnyObject]?, completion: @escaping CompletionBlock, failure: @escaping FailureBlock) {
    
        let headers :[String: String] = ["Content-Type": "application/json"]
        
        Alamofire.request(url,
                          method: requestType,
                          parameters: parameters,
                          encoding: JSONEncoding(options: []),
                          headers: headers).response { response in
                            
                            if let error = response.error {
                                failure(response.response, error)
                            }
                            
            }.responseJSON { response in
                completion(response.result.value)
        }
    }
}
