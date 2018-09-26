//
//  Webservice.swift
//  lwm
//
//  Created by Alex on 26.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class Webservice {
    
    func request<T>(ressource: Ressource<T>, timeout: TimeInterval = 10.0, completion: @escaping (Result<T>) -> Void) {
        let request = URLRequest(url: ressource.url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)
        ressource.configure(request)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            let result: Result<T>
            
            if let error = error {
                result = .failure(error)
            } else if let data = data {
                do {
                    let json = try ressource.parse(data)
                    result = .success(json)
                } catch let parseError {
                    result = .failure(parseError)
                }
            } else {
                fatalError("this should never happen")
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
}

enum HttpMethod {
    case get
    case post(body: Data?, contentType: String)
    case put(body: Data?, contentType: String)
    case delete
    
    var name: String {
        switch self {
        case .delete: return "delete"
        case .get: return "get"
        case .post: return "post"
        case .put: return "put"
        }
    }
}

struct Ressource<T> {
    let url: URL
    let configure: (URLRequest) -> Void
    let parse: (Data) throws -> T
}
