//
//  CollectionViewModel.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 20.11.2024.
//

import Foundation

final class CollectionViewModel {
    //Словарь только для того, чтобы в последующем формировать уникальные имена файлов для кеширования на диске из ключей словаря
    private let imagesURL = ["photo-1731700327903-824b789564f1":
                                "https://images.unsplash.com/photo-1731700327903-824b789564f1?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                             "photo-1731143061417-964b0768bd22":
                                "https://images.unsplash.com/photo-1731143061417-964b0768bd22?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                             "premium_photo-1729862338542-3664aeaf8c06":
                                "https://plus.unsplash.com/premium_photo-1729862338542-3664aeaf8c06?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                             "photo-1731493710740-136a5ce91c57":
                                "https://images.unsplash.com/photo-1731493710740-136a5ce91c57?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                             "photo-1472491235688-bdc81a63246e": "https://images.unsplash.com/photo-1472491235688-bdc81a63246e?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                             "premium_photo-1677545183884-421157b2da02":"https://plus.unsplash.com/premium_photo-1677545183884-421157b2da02?q=80&w=2944&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                             "photo-1573865526739-10659fec78a5":"https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=80&w=2815&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                             "photo-1541781774459-bb2af2f05b55":"https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?q=80&w=2920&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"]
    
    private let imagesCount: Int
    lazy var randomImages: [ImageViewModel] = []
    
    init(imagesCount: Int) {
        self.imagesCount = imagesCount
        generateRandomArray()
    }
    
    func generateRandomArray() {
        guard imagesCount > 0 else {
            return
        }
        
        for _ in 0..<imagesCount {
            if let randomElement = imagesURL.randomElement(), let imageURL = URL(string: randomElement.value) {
                randomImages.append(.init(fileName: randomElement.key, imageURL: imageURL))
            }
        }
    }
}
