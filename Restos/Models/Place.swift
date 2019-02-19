//
//  Place.swift
//  Restos
//
//  Created by Alejandro on 18/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

protocol Coordinate {
    var latitude: Double { get }
    var longitude: Double { get }
}

protocol POI {
    var label: String { get }
    var isVerified: Bool { get }
    var numberOfCheckins: Int { get }
    var distance: Double { get }
    var formattedAddress: String { get }
}

typealias Place = POI & Coordinate

