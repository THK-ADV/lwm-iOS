//
//  LoginValidator.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

fileprivate extension UITextField {
    
    var textOrNil: String? {
        guard let text = text else {
            return nil
        }
        
        return text.isEmpty ? nil : text
    }
}

final class LoginValidator: NSObject, UITextFieldDelegate {    
    private let usernameTextField: UITextField
    private let passwordTextField: UITextField
    private let button: UIButton
    
    init(usernameTextField: UITextField, passwordTextField: UITextField, button: UIButton) {
        self.usernameTextField = usernameTextField
        self.passwordTextField = passwordTextField
        self.button = button
        
        super.init()
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        updateAppearance()
    }
    
    var login: (username: String, password: String)? {
        guard let username = usernameTextField.textOrNil, let password = passwordTextField.textOrNil else { return nil }
        return (username: username, password: password)
    }
    
    private func updateAppearance() {
        let username = usernameTextField.textOrNil
        let password = passwordTextField.textOrNil
        
        switch (username, password) {
        case (.some, .some):
            validationAppearance(of: button, is: true)
        case (.some, .none):
            validationAppearance(of: button, is: false)
        case (.none, .some):
            validationAppearance(of: button, is: false)
        case (.none, .none):
            validationAppearance(of: button, is: false)
        }
    }
    
    private func validationAppearance(of button: UIButton, is enabled: Bool) {
        button.isUserInteractionEnabled = enabled
        button.alpha = enabled ? 1.0 : 0.5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateAppearance()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateAppearance()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateAppearance()
    }
}
