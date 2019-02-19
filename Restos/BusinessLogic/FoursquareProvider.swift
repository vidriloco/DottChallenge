//
//  FoursquareProvider.swift
//  Restos
//
//  Created by Alejandro on 18/02/2019.
//  Copyright © 2019 Alejandro. All rights reserved.
//

import Foundation

class FoursquareProvider {
    typealias FoursquarePlace = Response.Venue
    
    struct Response: Decodable {
        let response: PlacesList
        
        struct PlacesList: Decodable {
            let venues: [Venue]
        }
        
        struct Venue: Decodable, Place {
            
            enum Category: String, PlaceCategory {
                case restaurant = "4d4b7105d754a06374d81259"
                
                var id : String {
                    return self.rawValue
                }
            }
            
            struct Location: Decodable {
                let lat: Double
                let lng: Double
                let distance: Double
                let formattedAddress: [String]
            }
            
            struct Stats: Decodable {
                let checkinsCount: Int
            }
            
            private let id: String
            private let name: String
            private let verified: Bool
            private let stats: Stats
            private let location: Location
            
            var latitude: Double {
                return location.lat
            }
            
            var longitude: Double {
                return location.lng
            }
            
            var label: String {
                return name
            }
            
            var isVerified: Bool {
                return verified
            }
            
            var numberOfCheckins: Int {
                return stats.checkinsCount
            }
            
            var distance: Double {
                return location.distance
            }
            
            var formattedAddress: String {
                return location.formattedAddress.joined()
            }
            
        }
    }
    
    private let endpoint: String
    
    let credentialID = "HRBX4VDP52OQE4ZPPHJ1N1NRXFEUMHGXIYQSNRYLJPO3W35L"
    let clientSecret = "014E3TND0KS151GCUV5VIFS2OVL044HUKPSGCK42YFDHUNHH"
    
    private var dataTask: URLSessionDataTask?
    
    init(endpoint: String? = "https://api.foursquare.com/v2") {
        self.endpoint = endpoint!
    }
}

extension FoursquareProvider: PlacesProvider {
    
    private func urlForGettingPlaces(coordinate: Coordinate, limit: Int, radius: Int, categories: [PlaceCategory]) -> URL? {
        let enabledCategories = categories.map({ $0.id }).joined(separator: ",")
        let versioning = 20180218
        
        let url = URLBuilder(with: "\(endpoint)/venues/search")
            .with(paramKey: "ll", paramValue: "\(coordinate.latitude),\(coordinate.longitude)")
            .with(paramKey: "limit", paramValue: "\(limit)")
            .with(paramKey: "categoryId", paramValue: enabledCategories)
            .with(paramKey: "v", paramValue: "\(versioning)")
            .with(paramKey: "radius", paramValue: "\(radius)")
            .with(paramKey: "client_id", paramValue: credentialID)
            .with(paramKey: "client_secret", paramValue: clientSecret).build()
        
        return url
    }
    
    func getPlaces(around coordinate: Coordinate, limit: Int? = 10, radius: Int? = 1000, categories: [PlaceCategory], completion: @escaping (Result<[Place]>) -> Void) {
        dataTask?.cancel()
        
        let getPlacesURL = urlForGettingPlaces(coordinate: coordinate,
                                               limit: limit!,
                                               radius: radius!,
                                               categories: categories)
        
        guard let url = getPlacesURL else {
            completion(.fail(GenericError.malformedURL))
            return
        }
        
        let defaultSession = URLSession(configuration: .default)
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            
            if let error = error {
                
                completion(.fail(error))
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                let decoder = JSONDecoder()
                let places = try! decoder.decode(Response.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(places.response.venues))
                }
            }
            
        }
        dataTask?.resume()
    }
    
}
