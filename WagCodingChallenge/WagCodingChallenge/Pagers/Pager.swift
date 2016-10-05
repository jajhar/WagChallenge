//
//  Pager.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/04/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

public typealias PagerCompletionBlock = ([Any], Error?) -> Void

public class Pager : NSObject {
    
    private(set) var isEndOfPages : Bool
    private(set) var elements: [Any]
    internal(set) var nextPage: String?
    internal let dataCoordinator: DataCoordinator

    public override init() {
        
        self.isEndOfPages = false
        self.elements = []
        self.nextPage = ""
        self.dataCoordinator = DataCoordinator()
        
        super.init()
    }
    
    public func reloadWithCompletion(completion: PagerCompletionBlock?) {
        nextPage = nil
        isEndOfPages = false
        makeGetRequestWithCompletion(completion: completion, clearState: true)
    }
    
    public func getNextPageWithCompletion(completion: PagerCompletionBlock?) {
        makeGetRequestWithCompletion(completion: completion, clearState: false)
    }
    
    internal func makeGetRequestWithCompletion(completion: PagerCompletionBlock?, clearState: Bool) {
        
        makeGetRequestWithCompletion { (elementArray, error) -> Void in
            
            if(clearState && error == nil) {
                self.clearStateAndElements()
            }
            
            self.elements = elementArray
            
            completion?(self.elements, error)
        }
    }
    
    internal func makeGetRequestWithCompletion(completion: PagerCompletionBlock?) {
        // NOP (Handled by subclasses)
    }
    
    public func clearStateAndElements() {
        elements.removeAll()
        isEndOfPages = false
        nextPage = ""
    }
    
    public func markEndOfpages() {
        isEndOfPages = true
    }
        
}
