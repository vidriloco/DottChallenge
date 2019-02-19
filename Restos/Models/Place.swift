//
//  Place.swift
//  Restos
//
//  Created by Alejandro on 18/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

// MARK - Coordinate and POI protocols

protocol Coordinate {
    var latitude: Double { get }
    var longitude: Double { get }
}

protocol POI {
    var label: String { get }
    var isVerified: Bool { get }
    var numberOfCheckins: Int { get }
    var distance: Double { get }
    var formattedAddress: String { get }
}

typealias Place = POI & Coordinate

// MARK - Unique abstract class for Place protocol

extension FoursquareProvider {
    
    struct Response: Decodable {
        let response: PlacesList
        
        struct PlacesList: Decodable {
            let venues: [Venue]
        }
        
        struct Venue: Decodable, Place {
            
            struct Location: Decodable {
                let lat: Double
                let lng: Double
                let distance: Double
                let formattedAddress: [String]
            }
            
            struct Stats: Decodable {
                let checkinsCount: Int
            }
            
            private let id: String
            private let name: String
            private let verified: Bool
            private let stats: Stats
            private let location: Location
            
            var latitude: Double {
                return location.lat
            }
            
            var longitude: Double {
                return location.lng
            }
            
            var label: String {
                return name
            }
            
            var isVerified: Bool {
                return verified
            }
            
            var numberOfCheckins: Int {
                return stats.checkinsCount
            }
            
            var distance: Double {
                return location.distance
            }
            
            var formattedAddress: String {
                return location.formattedAddress.joined(separator: ", ")
            }
            
        }
    }
    
}
