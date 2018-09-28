//
//  Student.swift
//  lwm
//
//  Created by Student on 28.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Student: Codable {
    let systemId: String
    let lastname: String
    let firstname: String
    let email: String
    let registrationId: String
    let enrollment: UUID
    let id: UUID
}
