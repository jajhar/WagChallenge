//
//  ImageCache.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/5/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation
import UIKit

struct UIImageCache {

    static let shared: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        cache.name = "WagImageCache"
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
    
}

extension URL {
    
    // Returns whether or not retrieval was successful and the fetched Image
    typealias ImageCacheCompletion = (Bool, UIImage?) -> Void
    
    func fetchImage(completion: @escaping ImageCacheCompletion) {
        
        // First check if the cached image already exists
        if let cachedImage = UIImageCache.shared.object(forKey: absoluteString as NSString) as? UIImage {
            completion(true, cachedImage)
            return
        }
        
        // else download it from this URL
        let task = URLSession.shared.dataTask(with: self, completionHandler: { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
           
            guard let  data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
            // Store the image in cache
            UIImageCache.shared.setObject(image,
                                          forKey: self.absoluteString as NSString ,
                                          cost: data.count)
            
            DispatchQueue.main.async {
                completion(true, image)
            }
        })
        task.resume()
    }
    
}
