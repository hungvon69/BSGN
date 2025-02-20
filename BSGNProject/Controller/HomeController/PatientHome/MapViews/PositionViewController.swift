import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
class PositionViewController: UIViewController {
    

    @IBOutlet private weak var detailNotePstTextField: UITextField!
    @IBOutlet private weak var notConfirmButton: UIButton!
    @IBOutlet private weak var confỉmButton: UIButton!
    @IBOutlet private weak var locationTextField: UITextField!

    // Location Manager và Search Request
//    private let locationManager = CLLocationManager()
//    private let searchRequest = MKLocalSearch.Request()
    private var patient: Patient?
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.shared().getLocationModel({ [weak self] location in
            self?.locationTextField.text = location?.address
        })
        // Cấu hình LocationManager
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
    }
    

    @IBAction func notConfirmTapped(_ sender: Any) {
//        locationManager.stopUpdatingLocation()
        let mapVC = GoogleMapsViewController()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        print(GlobalService.appointmentData["patientName"])
        GlobalService.appointmentData["position"] = locationTextField.text
        GlobalService.appointmentData["positionNote"] = detailNotePstTextField.text
        GlobalService.shared.uploadAppointment { success, error in
            if success {
                print("Appointment uploaded successfully")
                let userID = Auth.auth().currentUser?.uid ?? ""
                GlobalService.shared.fetchUserData(uid: userID, isDoctor: false) { success in
                    switch success {
                    case .success(let userData):
                        self.patient = userData as! Patient
                        self.patient?.isInAppointment = 1
                        print("User data fetched successfully")
                    case .failure:
                        print("User data fetch failed")
                    }
                }
                self.showSuccessPopup()
                
            } else {
                print(error?.localizedDescription ?? "")
            }
            
        }
        guard let patiente = patient else {
            print("false")
            return }
        GlobalService.shared.updatePatientInfo(patient: patiente) { Result in
            switch Result {
            case .success:
                print("Patient updated successfully")
            case .failure:
                print("Patient update failed")
            }
            
        }
//        let mapVC = GoogleMapsViewController()
//        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    func showSuccessPopup() {
        CommonAlertView.present(.init(title: "Thông báo", subtitle: "Đăng ký khám thành công!", note: "Vui lòng chờ cho tới khi có bác sỹ nhận.")) {
            let myappointmentVC = HomeViewController()
            self.navigationController?.pushViewController(myappointmentVC, animated: true)
            myappointmentVC.navigationController?.navigationBar.isHidden = true
            
        }
    }
}


//// MARK: - CLLocationManagerDelegate
//extension PositionViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let userLocation = locations.last else { return }
//        print("User's current location: \(userLocation)")
//        GlobalService.appointmentData["longitude"] = userLocation.coordinate.longitude
//        GlobalService.appointmentData["latitude"] = userLocation.coordinate.latitude
//        // Tìm địa điểm gần nhất từ vị trí hiện tại
//        findNearestPlace(for: userLocation)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get location: \(error.localizedDescription)")
//        locationTextField.text = "Không thể lấy vị trí hiện tại."
//    }
//    
//}
