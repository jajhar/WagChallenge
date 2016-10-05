//
//  UserAPI.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/04/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import Alamofire

extension APICommunication {
    
    func getUsers(withCompletion completion: @escaping ([JSONDictionary]) -> Void, failure: @escaping FailureBlock) {        
        sendRequestWithURL(url: urlsManager.getUsers(),
                                requestType: .get,
                                 parameters: nil,
                                 completion: { (json) -> Void in
                                    
                                    guard let responseDict = json as? JSONDictionary else {
                                        print("\(#function) - ERROR: API Response is not JSON Compatible")
                                        failure(nil, nil)
                                        return
                                    }
                                    
                                    guard let responseArray = responseDict["items"] as? [JSONDictionary] else {
                                        print("\(#function) - ERROR: API Response missing data key")
                                        failure(nil, nil)
                                        return
                                    }
                                    
                                    completion(responseArray)
                                    
        }) { (response, error) -> Void in
            print("\(#function) - ERROR: \(error)")
            failure(response, error)
        }
    }
}

