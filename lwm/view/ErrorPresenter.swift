//
//  ErrorPresenter.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

struct ErrorPresenter {
    let error: Error
    
    func present(in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true)
    }
}
