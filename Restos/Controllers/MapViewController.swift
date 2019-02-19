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
    // Pass a generic and reduce dependency inversion here
    let foursquareProvider = FoursquareProvider()
    var markers = [MKAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurants"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureMap()
        determineCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
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
        mapView.delegate = self
        
    }
    
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func fetchRestaurants(around coordinate: Coordinate) {
        let restaurantTypes = [FoursquareProvider.Response.Venue.Category.restaurant]
        
        foursquareProvider.getPlaces(around: coordinate, limit: 40, categories: restaurantTypes) { (results) in
            switch results {
            case .success(let places):
                self.mapView.removeAnnotations(self.markers)
                self.markers = places.map({
                    return MapMarker(title: $0.label, coordinate: CLLocationCoordinate2DMake($0.latitude, $0.longitude))
                })
                self.markers.forEach { self.mapView.addAnnotation($0) }
                print(self.markers.count)
                
            default:
                print("Error")
            }
        }
    }

}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        let mapCenter = userLocation.coordinate
        
        let mapCamera = MKMapCamera(lookingAtCenter: mapCenter, fromEyeCoordinate: mapCenter, eyeAltitude: 6000)
        mapView.setCamera(mapCamera, animated: false)
        
        let coordinate = CLLocationCoordinate(location: userLocation)
        self.fetchRestaurants(around: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapMarker else { return nil }
        
        let identifier = "restaurant"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        fetchRestaurants(around: CLLocationCoordinate(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)))
    }
}
