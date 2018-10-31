//
//  AuthorityService.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Authority: Codable {
    let user: User
    let course: Course?
    let id: UUID
    
    private enum CodingKeys: String, CodingKey {
        case user
        case course
        case id
    }
    
    init(user: User, course: Course?, id: UUID) {
        self.user = user
        self.course = course
        self.id = id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let user: User
        
        if let student = try? container.decode(Student.self, forKey: .user) {
            user = .student(student)
        } else if let employee = try? container.decode(Employee.self, forKey: .user) {
            user = .employee(employee)
        } else {
            fatalError()
        }
        
        let course = try container.decodeIfPresent(Course.self, forKey: .course)
        let id = try container.decode(UUID.self, forKey: .id)
        
        self.init(user: user, course: course, id: id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch user {
        case .employee(let employee):
            try container.encode(employee, forKey: .user)
        case .student(let student):
            try container.encode(student, forKey: .user)
        }
        
        try container.encodeIfPresent(course, forKey: .course)
        try container.encode(id, forKey: .id)
    }
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
