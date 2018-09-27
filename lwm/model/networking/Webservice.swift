//
//  Webservice.swift
//  lwm
//
//  Created by Alex on 26.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

enum StatusCode: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case unsupportedMediaType = 415
    case internalServerError = 500
}

struct ErrorJson: Codable {
    let status: String
    let message: String
}

struct Ressource<T> {
    let url: URL
    let configure: (inout URLRequest) -> Void
    let parse: (Data) throws -> T
}

final class Webservice {
    
    private let urlSession: URLSession
    private let debug: Bool
    
    init(urlSession: URLSession, debug: Bool) {
        self.urlSession = urlSession
        self.debug = debug
    }
    
    var sessionCookie: HTTPCookie? {
        return urlSession.configuration.httpCookieStorage?.cookies?.first(where: { $0.name == "PLAY_SESSION" })
    }
    
    func request<T>(ressource: Ressource<T>, timeout: TimeInterval = 10.0, completion: @escaping (Result<T>) -> Void) {
        var request = URLRequest(url: ressource.url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)
        ressource.configure(&request)
        
        urlSession.dataTask(with: request) { (data, response, error) in
            let result: Result<T>
            
            if let error = error {
                result = .failure(error)
            } else if let data = data, let resp = response as? HTTPURLResponse {
                do {
                    guard let statusCode = StatusCode(rawValue: resp.statusCode) else {
                        fatalError()
                    }
                    
                    if self.debug { debugPrint(#function, resp) }
                    
                    switch statusCode {
                    case .ok:
                        let json = try ressource.parse(data)
                        result = .success(json)
                    case .notFound, .unauthorized, .unsupportedMediaType, .internalServerError, .badRequest:
                        let errorMsg = try JSONDecoder().decode(ErrorJson.self, from: data).message
                        let responseError = NSError(domain: #file, code: -1, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                        result = .failure(responseError)
                    }
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
