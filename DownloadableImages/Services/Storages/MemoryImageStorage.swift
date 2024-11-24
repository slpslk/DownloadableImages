//
//  MemoryImageStorage.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 22.11.2024.
//

import Foundation
import UIKit

final class MemoryImageStorage {
    let cache = NSCache<NSString, UIImage>()
    static let shared = MemoryImageStorage()
    
    func saveToMemoryStorage(_ image: UIImage, forKey key: NSString) {
        DispatchQueue.main.async { [weak self] in
            self?.cache.setObject(image, forKey: key)
        }
    }

    func getFromMemoryStorage(forKey key: NSString) -> UIImage? {
        cache.object(forKey: key)
    }
}
