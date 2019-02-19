//
//  Places.swift
//  Restos
//
//  Created by Alejandro on 18/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import CoreLocation

protocol PlaceCategory {
    var id : String { get }
}

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
