//
//  User.swift
//  lwm
//
//  Created by Student on 28.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum User {
    case employee(Employee)
    case student(Student)
}

enum UserStatus: String {
    case employee, lecturer, student
}
