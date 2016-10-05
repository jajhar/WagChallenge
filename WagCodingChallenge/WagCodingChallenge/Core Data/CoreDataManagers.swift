//
//  CoreDataManager.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/04/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataManager {
    
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
}

extension CoreDataManager {
    
    // MARK: User
    
    func createUser(wthJSON json: JSONDictionary, inManagedObjectContext context: NSManagedObjectContext?) -> User? {
        
        // account_id is a required field
        guard let objectId = json["account_id"] as? Int else {
            print("Warning: json account_id for user is not a Int value")
            return nil
        }
        
        // default to main context
        let managedContext: NSManagedObjectContext! = context != nil ? context! : persistentContainer.viewContext
        
        var user: User!
        
        managedContext.performAndWait {
            
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.predicate = NSPredicate(format: "id = %i", objectId)
            
            do {
                
                if let existingUser = try managedContext.fetch(request).first {
                    user = existingUser
                } else {
                    user = User(context: managedContext)
                }
                
                // Update the user object with the latest JSON from the server
                user.supplyJSONDictionary(json: json)
                
                try managedContext.save()
                
            } catch let error {
                print("Error: Failed to save User to Core Data: \(error)")
            }
        }
        
        return user
    }
}
