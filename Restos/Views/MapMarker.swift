//
//  MapMarker.swift
//  Restos
//
//  Created by Alejandro on 19/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import MapKit

class MapMarker: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let place: Place
    
    init(_ place: Place) {
        self.place = place
        self.title = place.label
        self.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        
        super.init()
    }
}
