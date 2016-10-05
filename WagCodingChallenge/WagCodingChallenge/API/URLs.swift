//
//  URLs.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/04/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

struct URLs {

    let baseURL = URL(string: "https://api.stackexchange.com/2.2")
    
}

extension URLs {
    // MARK: Users
    
    func getUsers() -> URL {
        let url : String = String(format: "users?site=stackoverflow")
        return URL(string: url, relativeTo: baseURL)!
    }
}
