//
//  DownloadOptions.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 22.11.2024.
//

import Foundation

enum DownloadOptions {
    enum From {
        case disk
        case memory
    }
    case circle
    case cached(From)
    case resize(CGSize)
}
