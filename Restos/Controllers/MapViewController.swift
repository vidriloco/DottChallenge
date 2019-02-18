//
//  MapViewController.swift
//  Restos
//
//  Created by Alejandro on 18/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurants"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureMap()
        determineCurrentLocation()
    }
    
    private func configureMap() {
        self.mapView = MKMapView().added(to: self)
            .withoutAutoConstraints()
            .with({ mapView in
                self.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
                mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                self.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
                mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        })
    
        // TODO: Move into the block
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = true
        mapView.showsUserLocation = true
    }
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        let mapCenter = userLocation.coordinate
        
        let mapCamera = MKMapCamera(lookingAtCenter: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 1000)
        mapView.setCamera(mapCamera, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
