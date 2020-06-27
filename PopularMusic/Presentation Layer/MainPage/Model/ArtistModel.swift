//
//  ArtistModel.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 26.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let topartists: Topartists
}

// MARK: - Topartists
struct Topartists: Codable {
    let artist: [Artist]?
    let attr: Attr

    enum CodingKeys: String, CodingKey {
        case artist
        case attr = "@attr"
    }
}

// MARK: - Artist
struct Artist: Codable {
    let name, listeners: String
    var mbid: String?
    var url: String?
    var streamable: String?
    var image: [Image]?
    var smallImage: Data?
    var largeImage: Data?
    var contry: String?
}

// MARK: - Image
struct Image: Codable {
    let text: String
    let size: Size

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

enum Size: String, Codable {
    case extralarge = "extralarge"
    case large = "large"
    case medium = "medium"
    case mega = "mega"
    case small = "small"
}

// MARK: - Attr
struct Attr: Codable {
    let country, page, perPage, totalPages: String
    let total: String
}
