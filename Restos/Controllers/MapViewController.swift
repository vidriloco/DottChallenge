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

    let placesProvider: PlacesProvider
    var placesHash = [String : Place]()
    
    let genericMapView: GenericMap
    
    // Given in meters
    let radiusRange = 500
    let displayedResults = 20
    
    var locationManager : CLLocationManager?

    init(placesProvider: PlacesProvider, mapView: GenericMap) {
        self.placesProvider = placesProvider
        self.genericMapView = mapView

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurants"
        determineCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        genericMapView.configure(with: self)
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
        
        placesProvider.getPlaces(around: coordinate,
                                 limit: displayedResults,
                                 radius: radiusRange,
                                 categories: restaurantTypes) { (results) in
            switch results {
            case .success(let places):
                self.placesHash.removeAll()
                places.forEach { self.placesHash[$0.identifier] = $0 }
                
                self.genericMapView.clearExistingPlaces()
                self.genericMapView.addPlacesToMap(places)
            default:
                print("Error")
            }
        }
    }

}

// MARK - CLLocationManagerDelegate methods

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        let coordinate = CLLocationCoordinate(location: userLocation)
        
        genericMapView.centerCameraOn(location: coordinate, animated: false)
        fetchRestaurants(around: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

// MARK - MKMapViewDelegate methods

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
        fetchRestaurants(around: CLLocationCoordinate(mapView.centerCoordinate))
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let mapMarker = view.annotation as? MapMarker, let place = placesHash[mapMarker.id] {
            navigationController?.pushViewController(PlaceDetailsViewController(place: place), animated: true)
        }
    }
}
