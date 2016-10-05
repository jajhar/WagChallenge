//
//  UserPager.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/4/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class UserPager: Pager {
    
    override func makeGetRequestWithCompletion(completion: PagerCompletionBlock?) {
        super.makeGetRequestWithCompletion(completion: completion)
        
        dataCoordinator.getUsers(withCompletion: { (newUsers) in
            completion?(newUsers, nil)
        }) { (error) in
            completion?([], error)
        }
    }
    
    override func clearStateAndElements() {
        super.clearStateAndElements()
        
    }
}
