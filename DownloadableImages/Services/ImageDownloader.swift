//
//  ImageDownloader.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 23.11.2024.
//

import Foundation
import UIKit

protocol ImageDownloading {
    func downloadImage( from url: URL,
                        completion: @escaping (UIImage?) -> Void)
}

final class ImageDownloader {}

extension ImageDownloader: ImageDownloading {
    func downloadImage(from url: URL,
                       completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
