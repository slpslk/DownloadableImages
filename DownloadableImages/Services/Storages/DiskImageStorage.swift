//
//  DiskImageStorage.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 23.11.2024.
//

import Foundation
import UIKit

final class DiskImageStorage {
    private var fileDirectory: URL? 
    private let concurrentQueue = DispatchQueue(label: "imageManagerQueue", attributes: .concurrent)
    
    static let shared = DiskImageStorage()
    
    init() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else {
            print("Не удалось найти директорию Documents.")
            return
        }
        
        self.fileDirectory = documentsDirectory
    }
    
    func saveToDiskStorage(_ image: UIImage, forKey key: NSString) {
        concurrentQueue.async(flags: .barrier) {
            if let imageData = image.pngData() {
                if let filePath = self.fileDirectory?.appendingPathComponent("\(key)") {
                    do {
                        try imageData.write(to: filePath)
                    } catch {
                        print("Ошибка при сохранении изображения \(key): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getFromDiskStorage(forKey: NSString, completion: @escaping (UIImage?) -> Void) {
        concurrentQueue.async {
            guard let fileDirectory = self.fileDirectory else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            do {
                let files = try FileManager.default.contentsOfDirectory(at: fileDirectory, includingPropertiesForKeys: nil, options: [])
                
                for fileURL in files {
                    let fileName = fileURL.lastPathComponent as NSString
                    
                    if fileName == forKey {
                        if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                completion(image)
                            }
                            return
                        }
                    }
                }
            } catch {
                print("Произошла ошибка при считывании содержимого директории: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}



