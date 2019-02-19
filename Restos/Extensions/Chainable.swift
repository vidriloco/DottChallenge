//
//  Chainable.swift
//  Restos
//
//  Created by Alejandro on 19/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import Foundation

public protocol Chainable {}
extension Chainable {
    @discardableResult public func with(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
    @discardableResult public func mutatingWith(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var value = self
        try block(&value)
        return value
    }
}
extension NSObject: Chainable {}

extension Dictionary {
    @discardableResult public func with(_ block: (Dictionary<Key,Value>) throws -> Void) rethrows -> Dictionary<Key,Value> {
        try block(self)
        return self
    }
    @discardableResult public func mutatingWith(_ block: (inout Dictionary<Key,Value>) throws -> Void) rethrows -> Dictionary<Key,Value> {
        var value = self
        try block(&value)
        return value
    }
}
