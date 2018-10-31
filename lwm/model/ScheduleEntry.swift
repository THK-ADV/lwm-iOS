//
//  ScheduleEntry.swift
//  lwm
//
//  Created by Student on 31.10.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

struct Group: Codable {
    let label: String
    let labwork: UUID
    let members: [UUID]
    let id: UUID
}

struct Room: Codable {
    let label: String
    let description: String
    let id: UUID
}

struct Degree: Codable {
    let label: String
    let abbreviation: String
    let id: UUID
}

struct Labwork: Codable {
    let label: String
    let description: String
    let semester: Semester
    let course: Course
    let degree: Degree
    let subscribable: Bool
    let published: Bool
    let id: UUID
}

struct ScheduleEntry: Codable {
    let labwork: Labwork
    let start: Date
    let end: Date
    let date: Date
    let room: Room
    let supervisor: [User]
    let group: Group
    let id: UUID
    
    private enum CodingKeys: String, CodingKey {
        case labwork
        case start
        case end
        case date
        case room
        case supervisor
        case group
        case id
    }
    
    init(labwork: Labwork, start: Date, end: Date, date: Date, room: Room, supervisor: [User], group: Group, id: UUID) {
        self.labwork = labwork
        self.start = start
        self.end = end
        self.date = date
        self.room = room
        self.supervisor = supervisor
        self.group = group
        self.id = id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = decoder.userInfo[CodingUserInfoKey.DateFormatter] as! DateFormatter
        let timeFormatter = decoder.userInfo[CodingUserInfoKey.TimeFormatter] as! DateFormatter
        
        let users: [User]

        if let students = try? container.decode([Student].self, forKey: .supervisor) {
            users = students.map { .student($0) }
        } else if let employees = try? container.decode([Employee].self, forKey: .supervisor) {
            users = employees.map { .employee($0) }
        } else {
            fatalError()
        }
        
        let labwork = try container.decode(Labwork.self, forKey: .labwork)
        let raw_start = try container.decode(String.self, forKey: .start)
        let raw_end = try container.decode(String.self, forKey: .end)
        let raw_date = try container.decode(String.self, forKey: .date)
        let room = try container.decode(Room.self, forKey: .room)
        let group = try container.decode(Group.self, forKey: .group)
        let id = try container.decode(UUID.self, forKey: .id)

        guard let start = timeFormatter.date(from: raw_start) else {
            throw NSError(domain: #file, code: -1, userInfo: [NSLocalizedDescriptionKey: "can't parse \(raw_start)"])
        }
        guard let end = timeFormatter.date(from: raw_end) else {
            throw NSError(domain: #file, code: -1, userInfo: [NSLocalizedDescriptionKey: "can't parse \(raw_end)"])
        }
        guard let date = dateFormatter.date(from: raw_date) else {
            throw NSError(domain: #file, code: -1, userInfo: [NSLocalizedDescriptionKey: "can't parse \(raw_date)"])
        }
        
        self.init(labwork: labwork, start: start, end: end, date: date, room: room, supervisor: users, group: group, id: id)
    }
    
    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        switch user {
//        case .employee(let employee):
//            try container.encode(employee, forKey: .user)
//        case .student(let student):
//            try container.encode(student, forKey: .user)
//        }
//
//        try container.encodeIfPresent(course, forKey: .course)
//        try container.encode(id, forKey: .id)
    }
}
