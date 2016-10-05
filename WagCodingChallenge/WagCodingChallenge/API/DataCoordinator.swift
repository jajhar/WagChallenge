//
//  DataCoordinator.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/5/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation
import CoreData

protocol DataCoordinatorProtocol {
    var api: APICommunication { get }
    var coreDataManager: CoreDataManager { get }
}

struct DataCoordinator: DataCoordinatorProtocol {
    
    let api = APICommunication()
    let coreDataManager = CoreDataManager()
    
    // NOTE: This should be called from a background thread
    func transferObjectsToMainThread<T: NSManagedObject>(objects: [T], completion: @escaping ([T]) -> Void) {
        
        // Passing of NSManagedObjectIDs is the only thread safe way to transfer NSManagedObjects between threads
        //  so we need to first capture the list of NSManagedObjectIDs
        var objectIds = [NSManagedObjectID]()
        for obj in objects {
            objectIds.append(obj.objectID)
        }
        
        // Switch back to main thread
        DispatchQueue.main.async {
            // Perform fetch on main thread using the main context to prevent data faults
            var mainThreadObjects = [T]()
            for id in objectIds {
                if let obj = try? self.coreDataManager.persistentContainer.viewContext.existingObject(with: id) as? T {
                    guard let obj = obj else { continue }
                    mainThreadObjects.append(obj)
                }
            }
            completion(mainThreadObjects)
        }
    }
}

extension DataCoordinator {
    
    // MARK: User
    
    func getUsers(withCompletion completion: @escaping ([User]) -> Void, failure: @escaping (Error?) -> Void) {
        
        api.getUsers(withCompletion: { (userJSONArray) in
            
            DispatchQueue.global().async {
                // Break off onto a background thread and create each user with the given raw JSON array
                var users = [User]()
                for rawUser in userJSONArray {
                    let privateContext = self.coreDataManager.persistentContainer.newBackgroundContext()
                    if let user = self.coreDataManager.createUser(wthJSON: rawUser,
                                                                  inManagedObjectContext: privateContext) {
                        users.append(user)
                    }
                }
                
                self.transferObjectsToMainThread(objects: users, completion: completion)
            }
            
        }) { (response, error) in
            failure(error)
        }
    }
    
}
