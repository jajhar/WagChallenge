//
//  User.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/04/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation
import CoreData


class User: ModelObject {

    override func supplyJSONDictionary(json: JSONDictionary) {
        super.supplyJSONDictionary(json: json)
        
        if let id = json["account_id"] as? Int32 {
            self.id = id
        }
        
        if let badges = json["badge_counts"] as? [String: Int] {
            if let bronzeCount = badges["bronze"] {
                bronzeBadgeCount = Int32(bronzeCount)
            }
            if let silverCount = badges["silver"] {
                silverBadgeCount = Int32(silverCount)
            }
            if let goldCount = badges["gold"] {
                goldBadgeCount = Int32(goldCount)
            }
        }
        
        if let username = json["display_name"] as? String {
            self.username = username
        }
        
        if let avatarURL = json["profile_image"] as? String {
            self.avatarURLString = avatarURL
        }
    }
    
    func getUserAvatarURL() -> URL? {
        guard let avatarString = avatarURLString else { return nil }
        guard let url = URL(string: avatarString) else { return nil }
        return url
    }

    
}
