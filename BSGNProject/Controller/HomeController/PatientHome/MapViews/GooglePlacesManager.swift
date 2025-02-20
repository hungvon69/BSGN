//
//  GooglePlacesManager.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 4/11/24.
//

import Foundation
import GooglePlaces
final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    static let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PlaceError: Error {
        case failedToGetPlace
    }
    
    public func search(
        query: String,
        completion: @escaping (Result<[Place], Error>) -> Void
    ) {
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        GooglePlacesManager.client.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: nil
        ) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlaceError.failedToGetPlace))
                print(error as Any)
                return
            }
            let places: [Place] = results.compactMap({
                Place(
                    id: $0.placeID,
                    name: $0.attributedFullText.string
                )
            })
            completion(.success(places))
        }
    }
    public func resolveLocation(
        for place: Place,
        completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ) {
        GooglePlacesManager.client.fetchPlace(
            fromPlaceID: place.id,
            placeFields: .coordinate,
            sessionToken: nil
        ) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlaceError.failedToGetPlace))
                
                return
            }
            let coordinate = CLLocationCoordinate2D(
                latitude: googlePlace.coordinate.latitude,
                longitude: googlePlace.coordinate.longitude
            )
            completion(.success(coordinate))
        }
    }
}
