//
//  CoreDataManager+Artist.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 26.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension CoreDataManager {
    
    func saveArtist(_ artist: Artist) {
        guard let country = artist.contry,
            var artistEntity = NSEntityDescription.insertNewObject(forEntityName: "ArtistEntity", into: managedObjectContext) as? ArtistEntity else { return }
        
        artistEntity = ArtistEntity(context: managedObjectContext)
        artistEntity.name = artist.name
        artistEntity.listeners = artist.listeners
        artistEntity.smallImage = artist.smallImage
        artistEntity.largeImage = artist.largeImage
        artistEntity.countryName = country
        saveContext()
    }
    
    func getArtistByCountry(_ country: String, artists: @escaping([Artist]?) -> Void) {
        let fetchRequest: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
        var artistsEntitiesContent: [ArtistEntity] = []
        var artistsContent: [Artist] = []
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if result.count > 0 {
                artistsEntitiesContent = result.filter{ $0.countryName == country }
                if !artistsEntitiesContent.isEmpty {
                    artistsEntitiesContent.forEach { item in
                        guard let artistModel = convertArtistEntityToArtistModel(item) else { return }
                        artistsContent.append(artistModel)
                    }
                }
            }
        } catch {
            artistsContent = []
        }
        artists(artistsContent)
    }
    
    func convertArtistEntityToArtistModel(_ model: ArtistEntity) -> Artist? {
        guard let name = model.name,
            let listeners = model.listeners,
            let country = model.countryName else { return nil }
        let artistModel = Artist(name: name,
                                 listeners: listeners,
                                 mbid: nil,
                                 url: nil,
                                 streamable: nil,
                                 image: nil,
                                 contry: country)
        return artistModel
    }
    
    func removeContentForCountry(_ country: String) {
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtistEntity")
        request.predicate = NSPredicate(format: "countryName = %@", country)
        do {
            let result = try managedObjectContext.fetch(request) as? [NSManagedObject]
            result?.forEach { item in
                managedObjectContext.delete(item)
            }
        } catch {
            print("Something wrong")
        }
        saveContext()
    }
}

