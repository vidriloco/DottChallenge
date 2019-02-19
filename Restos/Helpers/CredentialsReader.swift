//
//  CredentialsReader.swift
//  Restos
//
//  Created by Alejandro on 19/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import Foundation

protocol APICredentialsProvider {
    func clientID(for service: ThirdPartyAPIName) throws -> String
    func secretKey(for service: ThirdPartyAPIName) throws -> String
}

protocol ThirdPartyAPIName {
    var name : String { get }
}

enum ThirdPartyAPIProviders : String, ThirdPartyAPIName {
    case foursquare
    
    var name: String {
        return self.rawValue
    }
}

enum APICredentialReadErrors : Error {
    case couldNotReadAPICredentials
}

class CredentialsReader : APICredentialsProvider {

    enum Keys : String {
        case client
        case secret
    }
    
    let data : NSDictionary
    
    init(plist filename: String) {
        let path = Bundle.main.path(forResource: filename, ofType: "plist")!
        self.data = NSDictionary(contentsOfFile: path) ?? NSDictionary()
    }
    
    func clientID(for service: ThirdPartyAPIName) throws -> String {
        if let serviceRoot = serviceRoot(for: service.name),
            let client = serviceRoot.object(forKey: Keys.client.rawValue) as? String {
            return client
        }
        
        throw APICredentialReadErrors.couldNotReadAPICredentials
    }
    
    func secretKey(for service: ThirdPartyAPIName) throws -> String {
        if let serviceRoot = serviceRoot(for: service.name),
            let client = serviceRoot.object(forKey: Keys.secret.rawValue) as? String {
            return client
        }
        
        throw APICredentialReadErrors.couldNotReadAPICredentials
    }
    
    private func serviceRoot(for service: String) -> NSDictionary? {
        if let service = data.object(forKey: service) as? NSDictionary {
            return service
        }
        
        return nil
    }
    
}
