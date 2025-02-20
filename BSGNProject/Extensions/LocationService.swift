//
//  LocationService.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 25/11/24.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    // Singleton Instance
    static let shared = LocationService()
    
    var provinceData: [String] = []
    var districtData: [String] = []
    var xaData: [String] = []
    
    // Location Manager
    private let locationManager = CLLocationManager()
    
    // Callback cho trạng thái quyền truy cập
    var onAuthorizationStatusChanged: ((CLAuthorizationStatus) -> Void)?
    
    // Biến lưu vị trí hiện tại
    var currentLocation: CLLocation?
    
    // MARK: - Initializer
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Request Authorization
    
    /// Yêu cầu quyền truy cập vị trí khi sử dụng ứng dụng
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Yêu cầu quyền truy cập vị trí luôn luôn
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    /// Kiểm tra trạng thái quyền truy cập
    func checkAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    // MARK: - Start/Stop Updating Location
    
    /// Bắt đầu cập nhật vị trí
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// Dừng cập nhật vị trí
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Cập nhật vị trí hiện tại
        currentLocation = locations.last
        
        // Gửi thông báo khi có vị trí mới
        NotificationCenter.default.post(name: .locationDidUpdate, object: nil)
        
        print("Current Location: \(String(describing: currentLocation))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        onAuthorizationStatusChanged?(status)
        print("Authorization Status Changed: \(status)")
    }
}
extension Notification.Name {
    static let locationDidUpdate = Notification.Name("locationDidUpdate")
    static let mainLocationDidUpdate = Notification.Name("mainLocationDidUpdate")
}

