//
//  ArtistDetailViewController.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 26.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import UIKit

final class ArtistDetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var artistPhotoImageView: UIImageView!
    @IBOutlet private weak var listenersCountLabel: UILabel!
    
    //MARK: - Private Properties
    private var artist: Artist?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    //MARK: - Public Methods
    func configureWithArtist(_ artist: Artist) {
        self.artist = artist
    }
    
    //MARK: - Private
    private func configureController() {
        guard let artist = artist else { return }
        listenersCountLabel.text = artist.name + " (" + artist.listeners + " listeners)"
        guard let imageUrl = artist.image?.filter({ $0.size == .large }).first?.text else {
            artistPhotoImageView.image = UIImage(named: "placeholder")
            return
        }
        ImageLoader.shared.downladedImage(imageUrl, forImageView: artistPhotoImageView)
    }
    
}
