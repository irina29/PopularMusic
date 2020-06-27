//
//  ViewController.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 25.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var dataBaseSwitch: UISwitch!
    
    lazy var picker: UIPickerView = {
        let picker = UIPickerView.init()
        picker.delegate = viewModel
        picker.dataSource = viewModel
        picker.backgroundColor = .darkGray
        picker.tintColor = .black
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        let frame = CGRect(x: .zero,
                           y: UIScreen.main.bounds.size.height - 300,
                           width: UIScreen.main.bounds.size.width,
                           height: 300)
        picker.frame = frame
        return picker
    }()
    lazy var toolBar: UIToolbar = {
        let frame = CGRect(x: .zero,
                           y: UIScreen.main.bounds.size.height - 300,
                           width: UIScreen.main.bounds.size.width,
                           height: 50)
        let toolbar = UIToolbar.init(frame: frame)
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
    
    //MARK: - Properties
    lazy var viewModel: MainPageViewModel = {
        return MainPageViewModel(output: self, apiManager: apiManager)
    }()
    lazy var apiManager: ApiManager = {
        return ApiManager()
    }()
    var selectCountry: String?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reisterNibs()
        binding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Actions
    @IBAction func loadLocalData(_ sender: UISwitch) {
        tableView.backgroundColor = sender.isOn ? .systemBlue : .systemRed
        
        guard let countryName = countryBarButtonItem.title else { return }
        sender.isOn ? viewModel.loadLocalDataWithCountry(countryName) : viewModel.getArtistsByCountry(countryName)
    }
    
    @IBAction func changeCountry(_ sender: UIBarButtonItem) {
        self.view.addSubview(picker)
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        guard let selectCountry = selectCountry else { return }
        countryBarButtonItem.title = selectCountry
        dataBaseSwitch.isOn ? viewModel.loadLocalDataWithCountry(selectCountry) : viewModel.getArtistsByCountry(selectCountry)
        removeFromSuperView()
        
    }
    
    @objc func onCancelButtonTapped() {
        guard let selectCountry = selectCountry else { return }
        countryBarButtonItem.title = selectCountry
        viewModel.getArtistsByCountry(selectCountry)
        removeFromSuperView()
    }
    
    private func removeFromSuperView() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    //MARK: - Private
    private func reisterNibs() {
        tableView.register(UINib(nibName: "ArtistCell", bundle: nil), forCellReuseIdentifier: "ArtistCell")
    }
    
    private func binding() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
    
}

//MARK: - ViewController + MainPageViewModelOutput
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
