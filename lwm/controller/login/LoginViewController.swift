//
//  LoginViewController.swift
//  lwm
//
//  Created by Alex on 26.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

extension UIButton {
    
    func bordered(with backgroundColor: UIColor) {
        layer.backgroundColor = backgroundColor.cgColor
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = backgroundColor.cgColor
    }
}

final class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var validator: LoginValidator!
    private let login: Login?
    
    var loginTapped: (Login) -> Void = { _ in fatalError() }
    
    init(login: Login?) {
        self.login = login
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = login?.username
        passwordTextField.text = login?.password
        
        validator = LoginValidator(usernameTextField: usernameTextField, passwordTextField: passwordTextField, button: loginButton)
        loginButton.bordered(with: #colorLiteral(red: 0.7058823529, green: 0.1882352941, blue: 0.5725490196, alpha: 1))
    }

    @IBAction func login(_ sender: UIButton) {
        guard let (username, password) = validator.login else { return }
        
        loginTapped(Login(username: username, password: password))
    }
}
