//
//  LocationManager.swift
//  Snapheal
//
//  Created by Khanh Vu on 7/10/24.
//

import Foundation
import CoreLocation
import MapKit

typealias LocationCompletion = (CLLocation) -> ()

final class LocationManager: NSObject {
    //singleton
    private static var sharedLocationManager: LocationManager = {
        let locationManager = LocationManager()
        return locationManager
    }()
    
    class func shared() -> LocationManager {
        return sharedLocationManager
    }
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private var currentCompletion: LocationCompletion?
    private var locationCompletion: LocationCompletion?
    
    @UserDefault(.isRequestLocationPermission, defaultValue: false)
    private var isRequestLocationPermission: Bool
    
    private var isUpdatingLocation = false
    
    //MARK: - init
    override init() {
        super.init()
        configLocationManager()
    }

    func request() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    
    func getCurrentLocation(completion: @escaping LocationCompletion) {
        currentCompletion = completion
        locationManager.requestLocation()
    }
    
    func startUpdating(completion: @escaping LocationCompletion) {
        locationCompletion = completion
        isUpdatingLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
        isUpdatingLocation = false
    }
    
    func getLocationModel(_ completion: ((LocationModel?) -> Void)?) {
        guard let currentLocation = currentLocation else {
            return
        }
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                print("Geocoding failed with error: \(error.localizedDescription)")
                completion?(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                // Lấy name và title (locality or thoroughfare)
                let name = placemark.name
                var address = ""
                if let subThoroughfare = placemark.subThoroughfare {
                    address += subThoroughfare + " "
                }
                if let thoroughfare = placemark.thoroughfare {
                    address += thoroughfare + ", "
                }
                if let locality = placemark.locality {
                    address += locality + ", "
                }
                if let administrativeArea = placemark.administrativeArea {
                    address += administrativeArea + ", "
                }
                if let postalCode = placemark.postalCode {
                    address += postalCode + ", "
                }
                if let country = placemark.country {
                    address += country
                }
                let model = LocationModel(name: name, address: address, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                completion?(model)
            } else {
                completion?(nil)
            }
        }
    }
}

//MARK: - Private Method
private extension LocationManager {
    func configLocationManager() {
        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 10
//        locationManager.allowsBackgroundLocationUpdates = true
        currentLocation = locationManager.location
    }
    
    func showAlertRequiredLocationService() {
        CommonAlertView.present(.init(title: "Location Service Required!",
                                                subtitle: "Please enter settings to enable location service to use app",
                                                cancelTitle: "Cancel",
                                                doneTitle: "Open Settings")) {
            openSettings()
        }
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            manager.requestLocation()
            
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()
            
        case .denied, .restricted:
            print("user tap 'disallow' on the permission dialog, cant get location data")
            if isRequestLocationPermission {
                showAlertRequiredLocationService()
            } else {
                isRequestLocationPermission = true
            }
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
            manager.requestAlwaysAuthorization()
            
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
            
            if let current = currentCompletion {
                current(location)
            }
            
            if isUpdatingLocation, let updating = locationCompletion {
                updating(location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

struct LocationModel {
    let name: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    var coordiante: CLLocation? {
        guard let lat = latitude,
              let lon = longitude else { return nil }
        return .init(latitude: lat, longitude: lon)
    }
    
    var distanceMeter: Double? {
        guard let coordiante = coordiante,
              let currentLocation = LocationManager.shared().getCurrentLocation() else {
            return nil
        }
        return currentLocation.distance(from: coordiante)
    }
    
    var distanceKm: Double? {
        guard let distanceMeter = distanceMeter else {
            return nil
        }
        return distanceMeter / 1000.0
    }
    
    init(name: String?, address: String?, latitude: Double?, longitude: Double?) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func mock() -> Self {
        return .init(name: "Da nang", address: "danan ne", latitude: 16.06971707698294, longitude: 108.21644518260571)
    }
}
