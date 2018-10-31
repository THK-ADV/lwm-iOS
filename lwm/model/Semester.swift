//
//  Semester.swift
//  lwm
//
//  Created by Student on 31.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Semester: Codable {
    let label: String
    let abbreviation: String
    let start: Date
    let end: Date
    let examStart: Date
    let id: UUID
}
