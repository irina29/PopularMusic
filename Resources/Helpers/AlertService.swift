//
//  AlertService.swift
//  PopularMusic
//
//  Created by Irina Ryabchuk on 27.06.2020.
//  Copyright © 2020 IR. All rights reserved.
//

import UIKit

final class AlertService {
    
    //MARK: - Public Properties
    static let shared = AlertService()
    
    //MARK: - Public Methods
    func showAlert(controller: UIViewController, action: @escaping(Bool) -> Void) {
        let alertController = UIAlertController(title: "No Internet connection",
                                                message: "Load data from local storage?",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Load", style: .default, handler: { (_) in
            action(true)
        }))
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (_) in
            action(false)
        }))
        controller.present(alertController, animated: true)
    }

}
