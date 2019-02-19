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
    
    enum VenueTypes: String, PlaceCategory {
        case restaurant = "4d4b7105d754a06374d81259"
        
        var id : String {
            return self.rawValue
        }
    }
    
    private let endpoint: String
    
    let credentialID : String
    let clientSecret : String
    
    private var dataTask: URLSessionDataTask?
    
    init(endpoint: String? = "https://api.foursquare.com/v2", credentials: APICredentialsProvider) {
        self.endpoint = endpoint!
        self.credentialID = try! credentials.clientID(for: ThirdPartyAPIProviders.foursquare)
        self.clientSecret = try! credentials.secretKey(for: ThirdPartyAPIProviders.foursquare)
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
