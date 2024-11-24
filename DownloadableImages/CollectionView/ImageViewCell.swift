//
//  ImageViewCell.swift
//  DownloadableImages
//
//  Created by Sofya Avtsinova on 20.11.2024.
//

import Foundation
import UIKit

final class ImageViewCell: UICollectionViewCell {
    
    var imageViewModel: ImageViewModel? {
        didSet {
            guard let imageViewModel else {
                return
            }

            imageView.loadImage(from: imageViewModel, withOptions: [
                .circle,
                .cached(.memory),
                .resize(CGSize(width: contentView.bounds.width, height: contentView.bounds.height)),
                ])
        }
    }

    private lazy var imageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
