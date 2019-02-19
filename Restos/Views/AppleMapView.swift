//
//  AppleMapView.swift
//  Restos
//
//  Created by Alejandro on 19/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import MapKit

protocol GenericMap {
    func configure(with viewController: UIViewController)
    func centerMapOn(location coordinateLocation: Coordinate, animated: Bool)
    func addPlacesToMap(_ places: [Place])
    func clearExistingMarkers()
}

class AppleMapView: MKMapView, GenericMap {
    
    var existingMarkers = [MapMarker]()
    
    func configure(with viewController: UIViewController) {
        self.added(to: viewController)
            .withoutAutoConstraints()
            .with({ mapView in
                viewController.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                self.trailingAnchor.constraint(equalTo: viewController.trailingAnchor).isActive = true
                viewController.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                self.bottomAnchor.constraint(equalTo: viewController.bottomAnchor).isActive = true
                mapView.isZoomEnabled = true
                mapView.isPitchEnabled = true
                mapView.showsUserLocation = true
                if let mkMapViewDelegate = viewController as? MKMapViewDelegate {
                    mapView.delegate = mkMapViewDelegate
                }
            })
    }
    
    func centerMapOn(location coordinateLocation: Coordinate, animated: Bool) {
        let mapCenter = CLLocationCoordinate2DMake(coordinateLocation.latitude, coordinateLocation.longitude)
        
        let mapCamera = MKMapCamera(lookingAtCenter: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 6000)
        self.setCamera(mapCamera, animated: false)
    }
    
    func addPlacesToMap(_ places: [Place]) {
        existingMarkers = places.map({
            return MapMarker(title: $0.label, coordinate: CLLocationCoordinate2DMake($0.latitude, $0.longitude))
        })
        existingMarkers.forEach { self.addAnnotation($0) }
    }
    
    func clearExistingMarkers() {
        removeAnnotations(existingMarkers)
    }
}
