//
//  Places.swift
//  Restos
//
//  Created by Alejandro on 18/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import CoreLocation

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

protocol PlaceCategory {
    var id : String { get }
}

typealias Place = POI & Coordinate

protocol PlacesProvider {
    func getPlaces(around coordinate: Coordinate, limit: Int?, radius: Int?, categories: [PlaceCategory], completion: @escaping (Result<[Place]>) -> Void)
}

enum GenericError: Error {
    case malformedURL
}

struct CLLocationCoordinate: Coordinate {
    
    private let location: CLLocation
    
    init(location: CLLocation) {
        self.location = location
    }
    
    var latitude: Double {
        return self.location.coordinate.latitude
    }
    
    var longitude: Double {
        return self.location.coordinate.longitude
    }
}
