//
//  MainPageViewController.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 25.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import UIKit

final class MainPageViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var countryBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var dataBaseSwitch: UISwitch!
    
    //MARK: - Private Properties
    private lazy var picker: UIPickerView = {
        let frame = CGRect(x: .zero,
                           y: UIScreen.main.bounds.size.height - 300,
                           width: UIScreen.main.bounds.size.width,
                           height: 300)
        let picker = UIPickerView(frame: frame)
        picker.delegate = viewModel
        picker.dataSource = viewModel
        picker.backgroundColor = .darkGray
        picker.tintColor = .black
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        return picker
    }()
    private lazy var toolBar: UIToolbar = {
        let frame = CGRect(x: .zero,
                           y: UIScreen.main.bounds.size.height - 300,
                           width: UIScreen.main.bounds.size.width,
                           height: 50)
        let toolbar = UIToolbar(frame: frame)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done,
                                       target: self,
                                       action: #selector(onDoneButtonTapped))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                         target: self,
                                         action: #selector(onCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        toolbar.setItems([cancelItem, flexibleSpace, doneItem], animated: false)
        return toolbar
    }()
    private lazy var viewModel: MainPageViewModel = {
        return MainPageViewModel(output: self, apiManager: apiManager)
    }()
    private lazy var apiManager: ApiManager = {
        return ApiManager()
    }()
    private var selectCountry: String?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reisterNibs()
        binding()
    }
    
    //MARK: - Private Methods
    @objc private func onDoneButtonTapped() {
        guard let country = selectCountry == nil ? countryBarButtonItem.title : selectCountry else { return }
        countryBarButtonItem.title = country
        dataBaseSwitch.isOn ? viewModel.loadLocalDataWithCountry(country) : viewModel.getArtistsByCountry(country)
        removeFromSuperView()
    }
    
    @objc private func onCancelButtonTapped() {
        removeFromSuperView()
    }
    
    private func removeFromSuperView() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    private func reisterNibs() {
        tableView.register(UINib(nibName: "ArtistCell", bundle: nil), forCellReuseIdentifier: "ArtistCell")
        tableView.tableFooterView = UIView()
    }
    
    private func binding() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }

    //MARK: - Actions
    @IBAction private func loadLocalData(_ sender: UISwitch) {
        tableView.backgroundColor = sender.isOn ? .systemBlue : .systemRed
        guard let countryName = countryBarButtonItem.title else { return }
        sender.isOn ? viewModel.loadLocalDataWithCountry(countryName) : viewModel.getArtistsByCountry(countryName)
    }
    
    @IBAction private func changeCountry(_ sender: UIBarButtonItem) {
        let index = viewModel.countriesArray.firstIndex(of: countryBarButtonItem.title ?? "")
        picker.selectRow(index ?? 0, inComponent: 0, animated: false)
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    
}

//MARK: - MainPageViewController + MainPageViewModelOutput
extension MainPageViewController: MainPageViewModelOutput {
    func loadDataWithoutConnection(_ state: Bool) {
        AlertService.shared.showAlert(controller: self) { [weak self] result in
            guard let self = self,
                result else { return }
            self.dataBaseSwitch.isOn = state
            self.tableView.backgroundColor = state ? .systemBlue : .systemRed
            self.viewModel.loadLocalDataWithCountry(self.countryBarButtonItem.title ?? "")
        }
    }
    
    func didSelectCountry(_ country: String) {
        selectCountry = country
    }
    
    func didSelectRowWithArtist(_ artist: Artist) {
        guard let viewController = UIStoryboard.init(name: "ArtistDetailViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "ArtistDetailViewController") as? ArtistDetailViewController else { return }
        viewController.configureWithArtist(artist)
        viewController.view.backgroundColor = tableView.backgroundColor
        viewController.navigationController?.navigationBar.backgroundColor = .white
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func reloadData() {
        tableView.reloadData()
        if tableView.numberOfRows(inSection: 0) != 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
}
