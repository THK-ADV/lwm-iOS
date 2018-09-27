//
//  App.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

final class App {
    private let window: UIWindow
    private let webservice: Webservice
    private let userDefaults: UserDefaults
    
    init(window: UIWindow, webService: Webservice, userDefaults: UserDefaults) {
        self.webservice = webService
        self.userDefaults = userDefaults
        self.window = window
        self.window.tintColor = #colorLiteral(red: 0.7058823529, green: 0.1882352941, blue: 0.5725490196, alpha: 1)
        
        let loginViewController = LoginViewController(login: userDefaults.login)
        loginViewController.loginTapped = loginTapped

        self.window.rootViewController = loginViewController
    }
    
    private func loginTapped(_ login: Login) {
        LoginService(webService: webservice).login(login) { result in
            switch result {
            case .success(let session):
                self.userDefaults.login = login
                self.userDefaults.userId = session.userId
                self.authorities(for: session.userId)
                
            case .failure(let e):
                self.window.rootViewController.flatMap { ErrorPresenter(error: e).present(in: $0) }
            }
        }
    }
    
    private func authorities(for user: UUID) {
        AuthorityService(webService: webservice).authorities(for: user) { result in
            debugPrint(#function, result)
        }
    }
    
    func logUserDefaults() {
        userDefaults.dictionaryRepresentation().forEach { print($0) }
    }
}
