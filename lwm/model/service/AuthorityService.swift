//
//  AuthorityService.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Authority: Codable {
    let user: Employee
    let course: Course?
    let id: UUID
}

protocol User {
    var systemId: String { get }
    var lastname: String { get }
    var firstname: String { get }
    var email: String { get }
}

struct Employee: User, Codable {
    let systemId: String
    let lastname: String
    let firstname: String
    let email: String
    let status: String
    let id: UUID
}

struct Course: Codable {
    let label: String
    let description: String
    let abbreviation: String
    let lecturer: Employee
    let semesterIndex: Int
    let id: UUID
}

final class AuthorityService: LWMService {
    private let webService: Webservice
    
    init(webService: Webservice) {
        self.webService = webService
    }
    
    func authorities(for user: UUID, completion: @escaping (Result<[Authority]>) -> Void) {
        webService.request(ressource: ressource(for: user), completion: completion)
    }
    
    private func ressource(for user: UUID) -> Ressource<[Authority]> {
        return Ressource(
            url: URL(string: "\(AuthorityService.BaseURL.absoluteString)/atomic/authorities?user=\(user)")!,
            configure: { (request: inout URLRequest) in
                request.httpShouldHandleCookies = true
            }, parse: { data in
                try JSONDecoder().decode([Authority].self, from: self.unStream(data))
            }
        )
    }
}
