//
//  Result.swift
//  lwm
//
//  Created by Alex on 26.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
    
    public init(f: () throws -> T) {
        do {
            self = .success(try f())
        } catch {
            self = .failure(error)
        }
    }
}

public extension Result {
    
    public var value: T? {
        switch self {
        case .success(let s): return s
        case .failure: return nil
        }
    }
    
    public func flatMap<U>(_ f: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let s): return f(s)
        case .failure(let e): return .failure(e)
        }
    }
    
    public func map<U>(_ f: (T) -> U) -> Result<U> {
        return flatMap { .success(f($0)) }
    }
    
    public func run(_ f: (T) -> Void) {
        _ = map(f)
    }
    
    public func also(_ f: (T) -> Void) -> Result<T> {
        run(f); return self
    }
    
    public func resolve() throws -> T {
        switch self {
        case .success(let s): return s
        case .failure(let e): throw e
        }
    }
}
