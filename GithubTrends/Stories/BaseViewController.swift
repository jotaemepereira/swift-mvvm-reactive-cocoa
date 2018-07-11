//
//  BaseViewController.swift
//  GithubTrends
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    func showErrorAlert(alertMessage: String) {
        let alertController = UIAlertController(
            title: "Error!",
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
