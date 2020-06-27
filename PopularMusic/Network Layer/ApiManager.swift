//
//  ApiManager.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 26.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import Foundation

final class ApiManager: NSObject {
    
    //MARK: Properties
    static let shared = ApiManager()
    
    //MARK: Internal methods
    func downloadArtistInfoByContry(_ country: String, artistInfo: @escaping([Artist]?) -> Void) {
        let urlString = "http://ws.audioscrobbler.com/2.0/?method=geo.gettopartists&country=\(String(describing: country))&api_key=e81f61890b7ff8633ca024d0faa449e7&format=json"
        guard let url = URL(string: urlString) else { return }
        let artistRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: artistRequest) {(data, response, error) in
            guard error == nil else {
                print("error = \(String(describing: error?.localizedDescription))")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            switch httpResponse.statusCode {
            case 200...299:
                guard let jsonData = data,
                    let responseModel = try? JSONDecoder().decode(Welcome.self, from: jsonData),
                    let list = responseModel.topartists.artist else { return }
                DispatchQueue.main.async {
                    artistInfo(list)
                }
            default:
                artistInfo(nil)
            }
        }.resume()
    }
    
}
