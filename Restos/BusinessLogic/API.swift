//
//  API.swift
//  Restos
//
//  Created by Alejandro on 18/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import Foundation

public enum Result<DataType> {
    case success(DataType)
    case fail(Error)
}

public extension Result {
    
    func map<U>(_ transform: (DataType) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let val):
            return transform(val)
        case .fail(let e):
            return .fail(e)
        }
    }
    
    func transform<U>(_ transformer: (DataType) throws -> Result<U>) -> Result<U> {
        switch self {
        case .success(let val):
            do {
                return try transformer(val)
            } catch {
                return .fail(error)
            }
        case .fail(let e):
            return .fail(e)
        }
    }
}

class URLBuilder {
    
    private var urlString: String
    private var firstPair: Bool = true
    
    init(with host: String) {
        self.urlString = host
    }
    
    func with(paramKey: String, paramValue: String) -> URLBuilder {
        firstPair ? self.urlString.append("?") : self.urlString.append("&")
        firstPair = false
        self.urlString.append("\(paramKey)=\(paramValue)")
        return self
    }
    
    func build() -> URL? {
        return URL(string: urlString)
    }
}
