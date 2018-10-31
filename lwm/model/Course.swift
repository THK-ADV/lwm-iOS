//
//  Course.swift
//  lwm
//
//  Created by Student on 31.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Course: Codable {
    let label: String
    let description: String
    let abbreviation: String
    let lecturer: Employee
    let semesterIndex: Int
    let id: UUID
}
