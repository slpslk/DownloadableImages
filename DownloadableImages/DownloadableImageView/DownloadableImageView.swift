//
//  DownloadableImageView.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 20.11.2024.
//

import Foundation
import UIKit

protocol Downloadable {
    func loadImage(from imageInfo: ImageViewModel, withOptions: [DownloadOptions])
}

extension Downloadable where Self: UIImageView {
    func loadImage(from imageInfo: ImageViewModel, withOptions options: [DownloadOptions]) {
        let imageCacheInfo = CachedImageInfo(imageInfo, withOptions: options)
        
        ImageDownloadingManager.shared.getImage(imageInfo: imageCacheInfo, options: options) { image in
            guard let image else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

class DownloadableImageView: UIImageView, Downloadable {}
