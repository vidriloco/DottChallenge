//
//  MapMarker.swift
//  Restos
//
//  Created by Alejandro on 19/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import MapKit

class MapMarker: NSObject, MKAnnotation {
    let id: String
    let title: String?
    let distance: String?
    let coordinate: CLLocationCoordinate2D
    
    init(_ place: Place) {
        self.title = place.label
        self.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        self.distance = "\( place.distance) m"
        self.id = place.identifier
        super.init()
    }
    
    var subtitle: String? {
        return distance
    }
}
