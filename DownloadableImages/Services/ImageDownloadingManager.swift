//
//  ImageDownloadingManager.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 23.11.2024.
//

import Foundation
import UIKit

final class ImageDownloadingManager {
    private var runningRequests = [NSString: [((UIImage?) -> Void)]]()
    static let shared = ImageDownloadingManager(imageDownloader: ImageDownloader())
    
    private let imageDownloader: ImageDownloading
    
    init(imageDownloader: ImageDownloading) {
        self.imageDownloader = imageDownloader
    }
}

extension ImageDownloadingManager {
    func getImage(imageInfo: CachedImageInfo,
                  options: [DownloadOptions],
                  completion: @escaping (UIImage?) -> Void) {
        var key: NSString = imageInfo.fileName as NSString
        let optionsManager = ImageOptionsManager(imageInfo: imageInfo, options: options)
        
        //Проверка кеша
        if let cacheFrom = optionsManager.findCachedOption() {
            switch cacheFrom {
            case .memory:
                key = NSString(string: String(imageInfo.hashValue))
                if let cachedImage = MemoryImageStorage.shared.getFromMemoryStorage(forKey: key) {
                    optionsManager.processImage(image: cachedImage,
                                                cached: true) { transformedImage in
                        completion(transformedImage)
                    }
                    
                    return
                }
            case .disk:
                key = imageInfo.getImageFileName()
                DiskImageStorage.shared.getFromDiskStorage(forKey: key) { diskCachedImage in
                    if let diskCachedImage {
                        optionsManager.processImage(image: diskCachedImage,
                                                    cached: true) { transformedImage in
                            completion(transformedImage)
                        }
                        return
                    }
                }
            }
        }
        
        // Сохраняем запрос на картинку
        if runningRequests[key] != nil {
            runningRequests[key]?.append(completion)
            return
        } else {
            runningRequests[key] = [completion]
        }
        
        guard let url = URL(string: imageInfo.url) else {
            return
        }
        
        //Скачиваем картинку
        imageDownloader.downloadImage(from: url) { [weak self] image in
            guard let self, let image else {
                return
            }

            optionsManager.processImage(image: image, cached: false) { transformedImage in
                self.runningRequests[key]?.forEach { item in
                    item(transformedImage)
                }
                
                self.runningRequests[key] = nil
            }
        }
    }
}
