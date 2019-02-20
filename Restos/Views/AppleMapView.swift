//
//  AppleMapView.swift
//  Restos
//
//  Created by Alejandro on 19/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import MapKit

// MARK - Generic map view protocols

protocol GenericMap {
    func configure(with viewController: UIViewController)
    func centerCameraOn(location coordinateLocation: Coordinate, animated: Bool)
    func centerMapOn(location coordinateLocation: Coordinate, animated: Bool)
    func addPlacesToMap(_ places: [Place])
    func clearExistingPlaces()
}

// MARK - Apple map view wrapper around MKMapView

class AppleMapView: MKMapView, GenericMap {
    
    private var existingMarkers = Set<MapMarker>()
    private var allowedAltitudeRange = CLLocationDistance(3000)...CLLocationDistance(10000)
    
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
    
    func centerCameraOn(location coordinateLocation: Coordinate, animated: Bool) {
        let altitude = (allowedAltitudeRange ~= camera.altitude) ? camera.altitude : allowedAltitudeRange.lowerBound

        let mapCenter = CLLocationCoordinate2DMake(coordinateLocation.latitude, coordinateLocation.longitude)
        let mapCamera = MKMapCamera(lookingAtCenter: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: altitude)
        
        setCamera(mapCamera, animated: animated)
    }
    
    func centerMapOn(location coordinateLocation: Coordinate, animated: Bool) {
        let mapCenter = CLLocationCoordinate2DMake(coordinateLocation.latitude, coordinateLocation.longitude)

        setCenter(mapCenter, animated: animated)
    }
    
    func addPlacesToMap(_ places: [Place]) {
        existingMarkers = existingMarkers.union(places.map { MapMarker($0) })
        existingMarkers.forEach { addAnnotation($0) }
    }
    
    func clearExistingPlaces() {
        existingMarkers.forEach {
            let coordinatePoint = convert($0.coordinate, toPointTo: self)
            if !annotationVisibleRect.contains(coordinatePoint) {
                existingMarkers.remove($0)
                removeAnnotation($0)
            }
        }
    }
}
