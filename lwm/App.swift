//
//  App.swift
//  lwm
//
//  Created by Student on 27.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum HttpMethod: String {
    case get, put, post, delete
}

extension Ressource {

    static var BaseURL: URL {
        return URL(string: "http://praktikum.gm.fh-koeln.de:9000")!
    }
    
    static func unStream(_ data: Data) -> Data {
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
    
    static func build<T>(url: String, streamed: Bool = true, decoder: JSONDecoder = JSONDecoder(), method: HttpMethod = .get) -> Ressource<T> where T: Decodable {
        return Ressource<T>(
            url: URL(string: Ressource.BaseURL.absoluteString.appending(url))!,
            configure: { (request: inout URLRequest) in
                request.httpShouldHandleCookies = true
                request.httpMethod = method.rawValue
            }, parse: { try decoder.decode(T.self, from: streamed ? unStream($0) : $0) }
        )
    }
}

final class App {
    private let window: UIWindow
    private let webservice: Webservice
    private let userDefaults: UserDefaults
    
    init(window: UIWindow, webService: Webservice, userDefaults: UserDefaults) {
        self.webservice = webService
        self.userDefaults = userDefaults
        self.window = window
        self.window.tintColor = #colorLiteral(red: 0.7058823529, green: 0.1882352941, blue: 0.5725490196, alpha: 1)
        
        let loginViewController = LoginViewController(login: userDefaults.login)
        loginViewController.loginTapped = loginTapped

        self.window.rootViewController = loginViewController
    }
    
    private func loginTapped(_ login: Login) {
        LoginService(webService: webservice).login(login) { result in
            switch result {
            case .success(let session):
                self.userDefaults.login = login
                self.userDefaults.userId = session.userId
                
                self.currentSemester { $0.run { semester in
                    self.authorities(for: session.userId) { $0.run { auths in
                        self.scheduleEntries(for: semester, and: auths) { print(#function, $0) }
                    }}
                }}
                
            case .failure(let e):
                self.window.rootViewController.flatMap { ErrorPresenter(error: e).present(in: $0) }
            }
        }
    }
    
    func currentSemester(completion: @escaping (Result<Semester>) -> Void) {
        let d = JSONDecoder()
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        d.dateDecodingStrategy = .formatted(f)
        
        let r: Ressource<Semester> = Ressource<Semester>.build(url: "/semesters?select=current", streamed: false, decoder: d)
        webservice.request(ressource: r, completion: completion)
    }
    
    func scheduleEntries(for semester: Semester, and authorities: [Authority], completion: @escaping (Result<[ScheduleEntry]>) -> Void) {
        let d = JSONDecoder()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let tf = DateFormatter()
        tf.dateFormat = "hh:mm:ss"
        d.userInfo = [
            CodingUserInfoKey.DateFormatter: df,
            CodingUserInfoKey.TimeFormatter: tf
        ]
        
        authorities.compactMap { $0.course }.forEach { course in
            let r: Ressource<[ScheduleEntry]> = Ressource<[ScheduleEntry]>.build(url: "/courses/\(course.id)/atomic/scheduleEntries", streamed: true, decoder: d)
            webservice.request(ressource: r, completion: completion)
        }
    }
    
    private func authorities(for user: UUID, completion: @escaping (Result<[Authority]>) -> Void) {
        AuthorityService(webService: webservice).authorities(for: user, completion: completion)
    }
    
    func logUserDefaults() {
        userDefaults.dictionaryRepresentation().forEach { print($0) }
    }
}

extension CodingUserInfoKey {
    static let DateFormatter = CodingUserInfoKey(rawValue: "DateFormatter")!
    static let TimeFormatter = CodingUserInfoKey(rawValue: "TimeFormatter")!
}
