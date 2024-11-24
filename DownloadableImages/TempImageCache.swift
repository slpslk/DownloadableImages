//
//  TempImageCache.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 22.11.2024.
//

import Foundation
import UIKit

final class TempImageCache {
    let cache = NSCache<NSString, UIImage>()
    var keys = Set<NSString>()
    static let shared = TempImageCache()
    
    func saveToCache(_ image: UIImage, forKey key: NSString) {
        print("saved")
        cache.setObject(image, forKey: key)
        
        if let all = cache.value(forKey: "allObjects") as? NSArray {
            for object in all {
                print("object is \(object)")
            }
        }
    }
    
    func getFromCache(forKey key: NSString) -> UIImage? {
        var image: UIImage? = nil
        if let cachedImage = cache.object(forKey: key) {
            print("in cache")
            image = cachedImage
        }
        return image
    }
}


