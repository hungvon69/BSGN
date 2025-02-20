//
//  GoogleMapsViewController.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 31/10/24.
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, UISearchResultsUpdating {
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    var customPlace: Place?
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Chọn vị trí này", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor
        button.addTarget(GoogleMapsViewController.self, action: #selector(didTapSearch), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Maps"
        // Cấu hình Location Manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Tạo bản đồ với vị trí mặc định
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        setup()
    }
    private func setup() {
        customPlace?.name = "Custom Place"
        customPlace?.id = "custom"
        view.addSubview(button)
        view.bringSubviewToFront(button)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        button.frame = CGRect(x: 0, y: view.bounds.height - 100, width: view.bounds.width, height: 50)
        button.layer.cornerRadius = 25
        button.backgroundColor = mainColor
        button.tintColor = .black
    }
    
    // Nhận vị trí người dùng và cập nhật camera
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude,
                                                      zoom: 15.0)
            
            // Tạo marker cho vị trí của người dùng
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.title = "Bạn đang ở đây"
            marker.map = mapView
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    // Xử lý lỗi nếu không lấy được vị trí
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access was restricted or denied.")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, let resultVC = searchController.searchResultsController as? ResultsViewController
        else { return }
        
        GooglePlacesManager.shared.search(query: query) { results in
            switch results {
            case .success(let place):
                DispatchQueue.main.async {
                    resultVC.update(with: place)
                }
            case .failure(let error):
                print("Error while searching: \(error)")
            }
        }
        
    }

}
extension GoogleMapsViewController: ResultsViewControllerDelegate {
    func didSelectPlace(with coordinates: CLLocationCoordinate2D) {
        // Xóa các marker cũ (nếu cần)
        mapView.clear()

        // Tạo một marker mới
        let marker = GMSMarker()
        marker.position = coordinates
        marker.map = mapView
        
        // Di chuyển camera tới vị trí mới
        let cameraUpdate = GMSCameraUpdate.setCamera(
            GMSCameraPosition.camera(withLatitude: coordinates.latitude,
                                     longitude: coordinates.longitude,
                                     zoom: 12)
        )
        mapView.animate(with: cameraUpdate)
    }
    @objc func didTapSearch() {
        print("")
    }
}
