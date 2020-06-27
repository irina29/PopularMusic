//
//  MainPageViewModel.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 25.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import UIKit
import Reachability

protocol MainPageViewModelOutput: AnyObject {
    func loadDataWithoutConnection(_ state: Bool)
    func didSelectCountry(_ country: String)
    func didSelectRowWithArtist(_ artist: Artist)
    func reloadData()
}

final class MainPageViewModel: NSObject {
    
    //MARK: - Properties
    weak var viewModelOutput: MainPageViewModelOutput?
    unowned var apiManager: ApiManager
    var countriesArray = ["Argentina", "Belgium", "Ukraine"]
    private var content: [Artist]?
    private var artistModel: Artist?
    
    //MARK: - Init
    init(output: MainPageViewModelOutput, apiManager: ApiManager) {
        viewModelOutput = output
        self.apiManager = apiManager
        super.init()
        guard let country = countriesArray.first else { return }
        getArtistsByCountry(country)
    }
    
    //MARK: - Public Methods
    func getArtistsByCountry(_ country: String) {
        let reachability = try! Reachability()
        switch reachability.connection {
        case .wifi, .cellular:
            ApiManager.shared.downloadArtistInfoByContry(country) { [weak self] artists in
                guard let self = self,
                    let artists = artists else { return }
                self.content = artists.sorted { $0.name < $1.name }
                self.viewModelOutput?.reloadData()
                
                CoreDataManager.sharedInstance.removeContentForCountry(country)
                self.content?.forEach { item in
                    self.artistModel = item
                    self.artistModel?.contry = country
                    guard let artistModel = self.artistModel else { return }
                    CoreDataManager.sharedInstance.saveArtist(artistModel)
                }
            }
        default:
            viewModelOutput?.loadDataWithoutConnection(true)
            self.content = []
            self.viewModelOutput?.reloadData()
        }
    }
    
    func loadLocalDataWithCountry(_ country: String) {
        CoreDataManager.sharedInstance.getArtistByCountry(country, artists: { (items) in
            guard let artists = items else { return }
            self.content = artists.sorted { $0.name < $1.name }
            self.viewModelOutput?.reloadData()
        })
    }
    
}

//MARK: - MainPageViewModel + UITableViewDelegate
extension MainPageViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let content = content else { return }
        viewModelOutput?.didSelectRowWithArtist(content[indexPath.row])
    }
}

//MARK: - MainPageViewModel + UITableViewDataSource
extension MainPageViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let content = content else { return 0 }
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as? ArtistCell else { return UITableViewCell() }
        guard let content = content else { return UITableViewCell() }
        cell.configure(withArtist: content[indexPath.row])
        return cell
    }
}

//MARK: - MainPageViewModel + UIPickerViewDelegate
extension MainPageViewModel: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countriesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModelOutput?.didSelectCountry(countriesArray[row])
    }
    
}

//MARK: - MainPageViewModel + UIPickerViewDataSource
extension MainPageViewModel: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return countriesArray.count
     }
    
}
