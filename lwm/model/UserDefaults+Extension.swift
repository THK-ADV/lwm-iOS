//
//  UserDefaults+Extension.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var userId: UUID? {
        get { return string(forKey: #function).flatMap(UUID.init) }
        set { set(newValue?.uuidString, forKey: #function) }
    }
    
    var login: Login? {
        get { return data(forKey: #function).flatMap { try? PropertyListDecoder().decode(Login.self, from: $0) }}
        set { set(try? PropertyListEncoder().encode(newValue), forKey: #function) }
    }
}
