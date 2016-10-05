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
    
    func getUsers(withCompletion completion: @escaping ([User]) -> Void, failure: @escaping (Error?) -> Void) {
        
        api.getUsers(withCompletion: { (userJSONArray) in
            
            DispatchQueue.global().async {
                var users = [User]()
                for rawUser in userJSONArray {
                    let privateContext = self.coreDataManager.persistentContainer.newBackgroundContext()
                    if let user = self.coreDataManager.createUser(wthJSON: rawUser,
                                                                 inManagedObjectContext: privateContext) {
                        users.append(user)
                    }
                }
                
                // passing ids is the only thread safe way to transfer NSManagedObjects between threads
                var objectIds = [NSManagedObjectID]()
                for user in users {
                    objectIds.append(user.objectID)
                }
                
                // Switch back to main thread
                DispatchQueue.main.async {
                    // perform fetch on main thread to prevent data faults
                    var mainThreadUsers = [User]()
                    
                    for id in objectIds {
                        if let obj = try? self.coreDataManager.persistentContainer.viewContext.existingObject(with: id) as? User {
                            guard let obj = obj else { continue }
                            mainThreadUsers.append(obj)
                        }
                    }
                    completion(mainThreadUsers)
                }
            }
            
            }) { (response, error) in
                failure(error)
        }
    }
    
}
