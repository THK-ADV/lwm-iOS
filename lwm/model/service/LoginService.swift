//
//  LoginService.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Login: Codable {
    let username: String
    let password: String
}

struct Session {
    let userId: UUID
    let username: String
}

final class LoginService: LWMService {
    private let webService: Webservice
    
    init(webService: Webservice) {
        self.webService = webService
    }
    
    func login(_ login: Login, completion: @escaping (Result<Session>) -> Void) {
        webService.request(ressource: ressource(using: login), completion: completion)
    }
    
    private func ressource(using login: Login) -> Ressource<Session> {
        return Ressource(
            url: LoginService.BaseURL.appendingPathComponent("/sessions"),
            configure: { (request: inout URLRequest) in
                request.httpMethod = "POST"
                request.httpShouldHandleCookies = true
                request.httpBody = try? JSONEncoder().encode(login)
                request.setValue("application/vnd.fhk.login.V1+json", forHTTPHeaderField: "Content-Type")
            }, parse: { _ in
                let keys = ["user-id", "username"]
                let values = self.webService.sessionCookie?.value
                    .split(separator: "&")
                    .filter { s in keys.contains(where: { s.hasPrefix($0) }) }
                    .compactMap { $0.split(separator: "=").last }
                    .map(String.init) ?? []
                
                guard keys.count == values.count, let userId = values.first.flatMap(UUID.init), let username = values.last else {
                    fatalError()
                }
                
                return Session(userId: userId, username: username)
            }
        )
    }
}
