//
//  CachedImageInfo.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 22.11.2024.
//

import Foundation

//Структура для хранения информации в кеше об картинке и совершенных над ней операциях
struct CachedImageInfo: Hashable {
    let fileName: String
    let url: String
    var circled: Bool
    var resized: Bool
    
    init( _ imageInfo: ImageViewModel, withOptions options: [DownloadOptions]) {
        let urlString = imageInfo.imageURL.absoluteString
        var circled: Bool = false
        var resized: Bool = false
        
        outerLoop: for option in options {
            switch option {
            case .cached(let source):
                switch source {
                case .memory:
                    break outerLoop
                case .disk:
                    break outerLoop
                }
            case .circle:
                circled = true
                
            case .resize:
                resized = true
            }
        }
        self.fileName = imageInfo.fileName
        self.url = urlString
        self.circled = circled
        self.resized = resized
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(circled)
        hasher.combine(resized)
    }

    func getImageFileName() -> NSString {
        var imageFileName = fileName
        if circled {
            imageFileName += "_circled"
        }
        if resized {
            imageFileName += "_resized"
        }
        return imageFileName as NSString
    }
}
