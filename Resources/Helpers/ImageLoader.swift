//
//  ImageLoader.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 26.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import Foundation
import AlamofireImage

final class ImageLoader {
    
    //MARK: - Public Properties
    static let shared = ImageLoader()
    
    //MARK: - Private Properties
    private let downloader = ImageDownloader()
    
    //MARK: - Public Methods
    func downladedImage(_ linkImage: String, forImageView imageView: UIImageView) {
        guard let url = URL(string: linkImage) else { return }
        let urlRequest = URLRequest(url: url)
        
        downloader.download(urlRequest) { response in
            guard case .success(let image) = response.result else { return }
            imageView.image = image
        }
    }
    
}
