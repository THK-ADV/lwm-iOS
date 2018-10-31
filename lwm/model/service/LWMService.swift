//
//  LWMService.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

protocol LWMService {
    static var BaseURL: URL { get }
}

extension LWMService { // FIXME: remove?
    
    static var BaseURL: URL {
        return URL(string: "http://praktikum.gm.fh-koeln.de:9000")!
    }
    
    func unStream(_ data: Data) -> Data {
        guard var json = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "}{", with: "},{") else {
            fatalError()
        }
        
        json.insert("[", at: json.startIndex)
        json.insert("]", at: json.endIndex)
        
        guard let unStream = json.data(using: .utf8) else {
            fatalError()
        }
        
        return unStream
    }
}
