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

    let placesProvider : PlacesProvider
    let mapView: GenericMap
    
    var locationManager : CLLocationManager?

    init(placesProvider: PlacesProvider, mapView: GenericMap) {
        self.placesProvider = placesProvider
        self.mapView = mapView

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurants"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.configure(with: self)
        determineCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager?.stopUpdatingLocation()
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager().with { manager in
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            manager.distanceFilter = kCLDistanceFilterNone
            manager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func fetchRestaurants(around coordinate: Coordinate) {
        let restaurantTypes = [FoursquareProvider.VenueTypes.restaurant]
        
        placesProvider.getPlaces(around: coordinate, limit: 40, radius: 100, categories: restaurantTypes) { (results) in
            switch results {
            case .success(let places):
                self.mapView.clearExistingMarkers()
                self.mapView.addPlacesToMap(places)
            default:
                print("Error")
            }
        }
    }

}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        let coordinate = CLLocationCoordinate(location: userLocation)
        
        mapView.centerMapOn(location: coordinate, animated: false)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print(view.annotation?.title)
    }
}
