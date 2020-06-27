//
//  ArtistCell.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 25.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import UIKit

final class ArtistCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet private weak var artistPhotoImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var listenersCountLabel: UILabel!

    //MARK: - Internal
    func configure(withArtist artist: Artist) {
        artistNameLabel.text = artist.name
        listenersCountLabel.text = "(" + artist.listeners + " followers" + ")"
        
        guard let imageUrl = artist.image?.filter({ $0.size == .small }).first?.text else {
            return artistPhotoImageView.image = UIImage(named: "placeholder")
        }
        ImageLoader.shared.downladedImage(imageUrl, forImageView: artistPhotoImageView)

    }
    
}
