//
//  Interactor.swift
//  Restos
//
//  Created by Alejandro on 20/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import UIKit

class Interactor {
    
    private let placesProvider: PlacesProvider
    private let mapViewController: MapViewController?
    
    var mapVC : UIViewController? {
        return mapViewController
    }
    
    init(credentialsFile: String) {
        let credentialsReader = CredentialsReader(plist: credentialsFile)
        self.placesProvider = FoursquareProvider(credentials: credentialsReader)
        self.mapViewController = MapViewController(placesProvider: placesProvider, mapView: AppleMapView())
    }

}
