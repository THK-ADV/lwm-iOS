//
//  Employee.swift
//  lwm
//
//  Created by Student on 28.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Employee: Codable {
    let systemId: String
    let lastname: String
    let firstname: String
    let email: String
    let status: String //UserStatus
    let id: UUID
    
//    private enum CodingKeys: String, CodingKey {
//        case systemId
//        case lastname
//        case firstname
//        case email
//        case status
//        case id
//    }
//
//    init(systemId: String, lastname: String, firstname: String, email: String, status: UserStatus, id: UUID) {
//        self.systemId = systemId
//        self.lastname = lastname
//        self.firstname = firstname
//        self.email = email
//        self.status = status
//        self.id = id
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let systemId = try container.decode(String.self, forKey: .systemId)
//        let lastname = try container.decode(String.self, forKey: .lastname)
//        let firstname = try container.decode(String.self, forKey: .firstname)
//        let email = try container.decode(String.self, forKey: .email)
//        let status = try container.decode(String.self, forKey: .status)
//        let id = try container.decode(UUID.self, forKey: .id)
//
//        guard let statusType = UserStatus(rawValue: status) else {
//            throw NSError(domain: #file, code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown User Status"])
//        }
//
//        self.init(systemId: systemId, lastname: lastname, firstname: firstname, email: email, status: statusType, id: id)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(systemId, forKey: .systemId)
//        try container.encode(lastname, forKey: .lastname)
//        try container.encode(firstname, forKey: .firstname)
//        try container.encode(email, forKey: .email)
//        try container.encode(status.rawValue, forKey: .status)
//        try container.encode(id, forKey: .id)
//    }
}
