//
//  ImageOptionsManager.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 22.11.2024.
//

import Foundation
import UIKit

final class ImageOptionsManager {
    private var imageInfo: CachedImageInfo
    private var options: [DownloadOptions]
    let imageOptionsManagerQueue = DispatchQueue(label: "imageOptionsManagerQueue")
    
    
    init(imageInfo: CachedImageInfo, options: [DownloadOptions]) {
        self.imageInfo = imageInfo
        self.options = options
    }
    
    func processImage(image: UIImage, cached: Bool, completion: @escaping (UIImage) -> Void) {
        var transformedImage = image
        //Флаги для ослеживания необходимости в операции (была ли уже выполнена или нет)
        var isAlreadyCached = false
        var isAlreadyCircled = imageInfo.circled
        var isAlreadyResized = imageInfo.resized
        
        let dispatchGroup = DispatchGroup()
        
        for option in options {
            imageOptionsManagerQueue.async(group: dispatchGroup) {
                switch option {
                case .cached(let source) where !cached && !isAlreadyCached:
                    switch source {
                    case .memory:
                        MemoryImageStorage.shared.saveToMemoryStorage(transformedImage,
                                                      forKey: String(self.imageInfo.hashValue) as NSString)
                    case .disk:
                        DiskImageStorage.shared.saveToDiskStorage(transformedImage,
                                                               forKey: self.imageInfo.getImageFileName())
                    }
                    isAlreadyCached = true
                case .circle where  !(cached && isAlreadyCircled):
                    transformedImage = self.circleCrop(image: transformedImage)
                    isAlreadyCircled = true
                    
                case .resize(let size) where !(isAlreadyResized && cached):
                    transformedImage = self.resizeImage(image: transformedImage, targetSize: size)
                    isAlreadyResized = true
                default:
                    break
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(transformedImage)
        }
    }
    
    func findCachedOption() -> DownloadOptions.From? {
        for option in options {
            if case let .cached(from) = option {
                return from
            }
        }
        return nil
    }
}

private extension ImageOptionsManager {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func circleCrop(image: UIImage) -> UIImage {
        let minEdge = min(image.size.width, image.size.height)
        let targetSize = CGSize(width: minEdge, height: minEdge)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: targetSize)
            context.cgContext.addEllipse(in: rect)
            context.cgContext.clip()
            image.draw(in: rect)
        }
    }
}
