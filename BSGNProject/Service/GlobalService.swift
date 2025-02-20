import Firebase
import UIKit
import FirebaseDatabase
import FirebaseAuth

import FirebaseStorage

class GlobalService {
    static var appointmentData: [String: Any] = [
        "id": "00",
        "doctorID": "00",
        "patientID": "00",
        "doctorName": "00",
        "patientName": "00",
        "specialtyID": 0,
        "specialty": "00",
        "date": "00",
        "price": 0,
        "status": "Pending",
        "longitude": 0,
        "latitude": 0,
        "position": "00",
        "positionNote": "00",
        "symtoms": "00"
    ]
    var userData: [String: Any] = [
        "id": "",
        "name": "Nguyen",
        "lastName": "Van A",
        "phoneNumber": "0987654321",
        "address": "123 Đường ABC",
        "province": "Hà Nội",
        "district": "Cầu Giấy",
        "xa": "Dịch Vọng",
        "dateOfBirth": "1990-01-01",
        "avatar": "https://example.com/avatar.jpg",
        "sex": 1, // 1: Nam, 2: Nữ
        "blood": 0, // 0: Unknown
        "identifyNumber": "0123456789",
        "longitude": 105.804817,
        "latitude": 21.028511,
        "balance": 1000000,
        "isInAppointment": 0,
        "typeOfAccount": 0 // Mặc định cho patient
    ]
    let specialtyMapping: [Int: String] = [
        1: "Bệnh tim",
        2: "Bệnh về da",
        3: "Bệnh tiêu hóa",
        4: "Bệnh xương khớp",
        5: "Bệnh thần kinh",
        // Thêm các chuyên khoa khác theo yêu cầu
    ]
    let majorData: [String] = ["Tim mạch", "Da liễu", "Thần kinh", "Nhi khoa", "Chỉnh hình", "Nhãn khoa", "Tiêu hóa", "Hô hấp", "Sản khoa", "Nội tiết"]
    let bloodTypes = ["A", "B", "AB", "O"]
    static let shared = GlobalService()
    private let databaseRef = Database.database().reference().child("users")
    private let storage = Storage.storage().reference()
    private let database = Database.database().reference()
    
    private init() {}
    
    var idArticle: [String] = [
        "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11",
        "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22",
        "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33",
        "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44",
        "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55",
        "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66",
        "67", "68"
    ]
    
    func uploadAppointment(completion: @escaping (Bool, Error?) -> Void) {
        // Tạo ID ngẫu nhiên cho cuộc hẹn
        let appointmentID = database.child("appointments").childByAutoId().key ?? "unknownID"
        
        // Cập nhật `id` trong dữ liệu appointmentData
        GlobalService.appointmentData["id"] = appointmentID
        
        // Đường dẫn trong database nơi lưu dữ liệu cuộc hẹn
        let appointmentRef = database.child("appointments").child(appointmentID)
        
        // Upload dữ liệu từ `appointmentData`
        appointmentRef.setValue(GlobalService.appointmentData) { error, _ in
            if let error = error {
                print("Failed to upload appointment: \(error.localizedDescription)")
                completion(false, error) // Trả về thất bại và lỗi
            } else {
                print("Appointment uploaded successfully!")
                completion(true, nil) // Trả về thành công
            }
        }
    }

    
    func fetchAppointments(completion: @escaping ([Appointment]) -> Void, majorID: Int) {
        Database.database().reference().child("appointments").observeSingleEvent(of: .value) { snapshot in
            print("Snapshot: \(snapshot.value ?? "No Data")")
            
            var appointments: [Appointment] = []
            
            for child in snapshot.children {
                guard
                    let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String: Any],
                    let doctorID = data["doctorID"] as? String,
                    let doctorName = data["doctorName"] as? String,
                    let patientID = data["patientID"] as? String,
                    let patientName = data["patientName"] as? String,
                    let specialty = data["specialty"] as? String,
                    let specialtyID = data["specialtyID"] as? Int,
                    let price = data["price"] as? Int,
                    let longitude = data["longitude"] as? Double,
                    let latitude = data["latitude"] as? Double,
                    let status = data["status"] as? String,
                    let position = data["position"] as? String,
                    let positionNote = data["positionNote"] as? String,
                    let symtoms = data["symtoms"] as? String,
                    let date = data["date"] as? String
                else {
                    print("Invalid appointment data for child: \(child)")
                    continue
                }
                
                let appointment = Appointment(
                    id: childSnapshot.key,
                    doctorID: doctorID,
                    doctorName: doctorName,
                    patientID: patientID,
                    patientName: patientName,
                    specialty: specialty,
                    specialtyID: specialtyID,
                    price: price,
                    date: date,
                    longitude: longitude,
                    latitude: latitude,
                    position: position,
                    positionNote: positionNote,
                    symtoms: symtoms,
                    status: status
                )
                
                if appointment.specialtyID == majorID {
                    appointments.append(appointment)
                }
            }
            
            if appointments.isEmpty {
                print("No appointments found for majorID \(majorID)")
            }
            
            completion(appointments)
        }
    }
    
    func fetchAppointmentsWithPatientID(completion: @escaping ([Appointment]) -> Void, patient: String) {
        Database.database().reference().child("appointments").observeSingleEvent(of: .value) { snapshot in
            print("Snapshot: \(snapshot.value ?? "No Data")")
            
            var appointments: [Appointment] = []
            
            for child in snapshot.children {
                guard
                    let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String: Any],
                    let doctorID = data["doctorID"] as? String,
                    let doctorName = data["doctorName"] as? String,
                    let patientID = data["patientID"] as? String,
                    let patientName = data["patientName"] as? String,
                    let specialty = data["specialty"] as? String,
                    let specialtyID = data["specialtyID"] as? Int,
                    let price = data["price"] as? Int,
                    let longitude = data["longitude"] as? Double,
                    let latitude = data["latitude"] as? Double,
                    let status = data["status"] as? String,
                    let position = data["position"] as? String,
                    let positionNote = data["positionNote"] as? String,
                    let symtoms = data["symtoms"] as? String,
                    let date = data["date"] as? String
                else {
                    print("Invalid appointment data for child: \(child)")
                    continue
                }
                
                let appointment = Appointment(
                    id: childSnapshot.key,
                    doctorID: doctorID,
                    doctorName: doctorName,
                    patientID: patientID,
                    patientName: patientName,
                    specialty: specialty,
                    specialtyID: specialtyID,
                    price: price,
                    date: date,
                    longitude: longitude,
                    latitude: latitude,
                    position: position,
                    positionNote: positionNote,
                    symtoms: symtoms,
                    status: status
                )
                
                if appointment.patientID == patient {
                    appointments.append(appointment)
                    print("======")
                }
            }
            
            if appointments.isEmpty {
                print("No appointments found for patient \(patient)")
            }
            
            completion(appointments)
        }
    }
    func loadAppointmentWithID(appointmentID: String, completion: @escaping (Result<Appointment, Error>) -> Void) {
        // Đường dẫn tới cuộc hẹn trong Firebase
        let appointmentRef = database.child("appointments").child(appointmentID)

        // Lấy dữ liệu từ Firebase
        appointmentRef.observeSingleEvent(of: .value) { snapshot  in
            guard let data = snapshot.value as? [String: Any] else {
                let error = NSError(domain: "com.example.app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Appointment not found"])
                completion(.failure(error))
                return
            }

            // Parse dữ liệu từ snapshot
            guard
                let doctorID = data["doctorID"] as? String,
                let doctorName = data["doctorName"] as? String,
                let patientID = data["patientID"] as? String,
                let patientName = data["patientName"] as? String,
                let specialty = data["specialty"] as? String,
                let specialtyID = data["specialtyID"] as? Int,
                let price = data["price"] as? Int,
                let longitude = data["longitude"] as? Double,
                let latitude = data["latitude"] as? Double,
                let status = data["status"] as? String,
                let position = data["position"] as? String,
                let positionNote = data["positionNote"] as? String,
                let symtoms = data["symtoms"] as? String,
                let date = data["date"] as? String
            else {
                let error = NSError(domain: "com.example.app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Appointment not found"])
                completion(.failure(error))
                return
            }

            // Tạo đối tượng Appointment từ dữ liệu
            let appointment = Appointment(
                id: appointmentID,
                doctorID: doctorID,
                doctorName: doctorName,
                patientID: patientID,
                patientName: patientName,
                specialty: specialty,
                specialtyID: specialtyID,
                price: price,
                date: date,
                longitude: longitude,
                latitude: latitude,
                position: position,
                positionNote: positionNote,
                symtoms: symtoms,
                status: status
            )

            // Trả về kết quả thành công
            completion(.success(appointment))
        } withCancel: { error in
            // Xử lý lỗi khi truy vấn Firebase
            completion(.failure(error))
        }
    }
    func updateAppointmentStatus(appointment: Appointment, doctorID: String, doctorName: String) {
        let updatedAppointment = Appointment(
            id: appointment.id,
            doctorID: appointment.doctorID,
            doctorName: appointment.doctorName,
            patientID: appointment.patientID,
            patientName: appointment.patientName,
            specialty: appointment.specialty,
            specialtyID: appointment.specialtyID,
            price: appointment.price,
            date: appointment.date,
            longitude: appointment.longitude,
            latitude: appointment.latitude,
            position: appointment.position,
            positionNote: appointment.positionNote,
            symtoms: appointment.symtoms,
            status: "accepted"
        )

        // Gửi cập nhật vào Firebase
        let ref = Database.database().reference().child("appointments").child(appointment.id)
        ref.setValue(updatedAppointment.toDictionary())
    }
    func loadPatientWithID(patientID: String, completion: @escaping (Result<Patient, Error>) -> Void) {
        // Đường dẫn tới bệnh nhân trong Firebase
        let patientRef = database.child("users").child("patients").child(patientID)
        print(patientRef)

        // Lấy dữ liệu từ Firebase
        patientRef.observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {
                let error = NSError(domain: "com.example.app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Patient not found"])
                completion(.failure(error))
                return
            }

            // Parse dữ liệu từ snapshot
            guard
                let id = data["id"] as? String,
                let name = data["name"] as? String,
                let lastName = data["lastName"] as? String,
                let phoneNumber = data["phoneNumber"] as? String,
                let address = data["address"] as? String,
                let province = data["province"] as? String,
                let district = data["district"] as? String,
                let xa = data["xa"] as? String,
                let dateOfBirth = data["dateOfBirth"] as? String,
                let avatar = data["avatar"] as? String,
                let sex = data["sex"] as? String,
                let blood = data["blood"] as? String,
                let identifyNumber = data["identifyNumber"] as? String,
                let longitude = data["longitude"] as? Double,
                let latitude = data["latitude"] as? Double,
                let balance = data["balance"] as? Int,
                let isInAppointment = data["isInAppointment"] as? Int,
                let typeOfAccount = data["typeOfAccount"] as? Int
            else {
                let error = NSError(domain: "com.example.app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid patient data"])
                completion(.failure(error))
                return
            }

            // Tạo đối tượng Patient từ dữ liệu
            let patient = Patient(
                id: id,
                name: name,
                lastName: lastName,
                phoneNumber: phoneNumber,
                address: address,
                province: province,
                district: district,
                xa: xa,
                dateOfBirth: dateOfBirth,
                avatar: avatar,
                sex: sex,
                blood: blood,
                identifyNumber: identifyNumber,
                longitude: longitude,
                latitude: latitude,
                balance: balance,
                isInAppointment: isInAppointment,
                typeOfAccount: typeOfAccount
            )

            // Trả về kết quả thành công
            completion(.success(patient))
        } withCancel: { error in
            // Xử lý lỗi khi truy vấn Firebase
            completion(.failure(error))
        }
    }
    func loadDoctorWithID(doctorID: String, completion: @escaping (Result<Doctor, Error>) -> Void) {
        // Đường dẫn tới doctor trong Firebase
        let doctorRef = database.child("users").child("doctors").child(doctorID)
        
        // Lấy dữ liệu từ Firebase
        doctorRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                let error = NSError(domain: "com.example.app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Doctor not found"])
                completion(.failure(error))
                return
            }
            
            do {
                // Chuyển dữ liệu snapshot thành JSON
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let decoder = JSONDecoder()
                
                // Decode JSON thành Doctor
                let doctor = try decoder.decode(Doctor.self, from: jsonData)
                completion(.success(doctor))
            } catch {
                let parseError = NSError(domain: "com.example.app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse doctor data"])
                completion(.failure(parseError))
            }
            
        }) { error in
            // Xử lý lỗi khi truy cập Firebase
            completion(.failure(error))
        }
    }

    // MARK: - Register User
    func registerUser(email: String, password: String, isDoctor: Bool, additionalInfo: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = authResult?.user.uid else {
                completion(.failure(NSError(domain: "UserIDError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve user ID."])))
                return
            }
            
            // Set typeOfAccount based on user role
            var userInfo = additionalInfo
            userInfo["id"] = uid
            userInfo["typeOfAccount"] = isDoctor ? 1 : 0
            
            let userTypeRef = isDoctor ? self.databaseRef.child("doctors").child(uid) : self.databaseRef.child("patients").child(uid)
            userTypeRef.setValue(userInfo) { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    // MARK: - Fetch User Data
    func fetchUserData(uid: String, isDoctor: Bool, completion: @escaping (Result<Any, Error>) -> Void) {
        let userTypeRef = isDoctor ? self.databaseRef.child("doctors").child(uid) : self.databaseRef.child("patients").child(uid)
        
        userTypeRef.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                completion(.failure(NSError(domain: "UserDataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found."])))
                return
            }
            
            do {
                if isDoctor {
                    let doctorData = try JSONDecoder().decode(Doctor.self, from: JSONSerialization.data(withJSONObject: userData))
                    completion(.success(doctorData))
                } else {
                    let patientData = try JSONDecoder().decode(Patient.self, from: JSONSerialization.data(withJSONObject: userData))
                    completion(.success(patientData))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update User Data
    func updateUserData(uid: String, isDoctor: Bool, updatedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let userTypeRef = isDoctor ? self.databaseRef.child("doctors").child(uid) : self.databaseRef.child("patients").child(uid)
        
        userTypeRef.updateChildValues(updatedData) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    func uploadAvatar(imageData: Data, typeOfAccount: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user is logged in.")
            completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        // Lưu avatar vào Storage với UID của người dùng
        let avatarRef = storage.child("avatars/\(currentUser.uid).jpg")
        
        avatarRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            // Lấy URL của ảnh đã upload
            avatarRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve download URL: \(error.localizedDescription)")
                    completion(error)
                    return
                }
                
                guard let downloadURL = url else {
                    print("Download URL is nil")
                    completion(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Download URL is nil"]))
                    return
                }
                
                // Lấy typeOfAccount từ Realtime Database để xác định là doctor hay patient
                self.database.child("users").child(typeOfAccount).child(currentUser.uid).observeSingleEvent(of: .value) { snapshot in
                    guard let userData = snapshot.value as? [String: Any] else {
                        print("Snapshot is nil or not a dictionary")
                        completion(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Snapshot is nil or not a dictionary"]))
                        return
                    }
                    
                    print("User data: \(userData)") // In ra toàn bộ dữ liệu để kiểm tra

                    guard let typeOfAccount = userData["typeOfAccount"] as? Int else {
                        print("typeOfAccount is missing or invalid")
                        completion(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "typeOfAccount is missing or invalid"]))
                        return
                    }
                    
                    let userBranch = (typeOfAccount == 1) ? "doctors" : "patients"
                    let userRef = self.database.child("users").child(userBranch).child(currentUser.uid)
                    userRef.updateChildValues(["avatar": downloadURL.absoluteString]) { error, _ in
                        if let error = error {
                            print("Failed to update avatar URL in Realtime Database: \(error.localizedDescription)")
                            completion(error)
                        } else {
                            print("Avatar URL successfully updated in Realtime Database")
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    func updateDoctorInfo(doctor: Doctor, completion: @escaping (Result<Void, Error>) -> Void) {
        // Đường dẫn tới thông tin doctor trong Firebase
        let doctorRef = database.child("users").child("doctors").child(doctor.id)

        // Chuyển đối tượng Doctor thành từ điển
        guard let doctorData = try? JSONEncoder().encode(doctor),
              let doctorDict = try? JSONSerialization.jsonObject(with: doctorData, options: []) as? [String: Any] else {
            let error = NSError(domain: "com.example.app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to encode doctor data"])
            completion(.failure(error))
            return
        }

        // Cập nhật dữ liệu lên Firebase
        doctorRef.updateChildValues(doctorDict) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    func updatePatientInfo(patient: Patient, completion: @escaping (Result<Void, Error>) -> Void) {
        // Đường dẫn tới thông tin patient trong Firebase
        let patientRef = database.child("users").child("patients").child(patient.id)

        // Chuyển đối tượng Patient thành từ điển
        guard let patientData = try? JSONEncoder().encode(patient),
              let patientDict = try? JSONSerialization.jsonObject(with: patientData, options: []) as? [String: Any] else {
            let error = NSError(domain: "com.example.app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to encode patient data"])
            completion(.failure(error))
            return
        }

        // Cập nhật dữ liệu lên Firebase
        patientRef.updateChildValues(patientDict) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }


    func fetchDoctorProfile(uid: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        // Truy cập vào đường dẫn của doctor trong Firebase
        let doctorRef = self.databaseRef.child("doctors").child(uid)
        
        doctorRef.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                completion(.failure(NSError(domain: "UserDataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Doctor data not found."])))
                return
            }
            
            // Lấy URL avatar và tên từ dữ liệu Firebase
            guard let avatarURL = userData["avatar"] as? String,
                  let name = userData["firstName"] as? String else {
                completion(.failure(NSError(domain: "DataError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Missing avatar or name"])))
                return
            }
            
            // Trả về URL avatar và tên
            completion(.success((avatarURL, name)))
        }
    }
    func fetchArticlesFromFirebase(articleID: String, completion: @escaping (Result<Article, Error>) -> Void) {
        // Đường dẫn tới bài viết trong Firebase
        let articleRef = database.child("articles").child(articleID)
        
        // Lấy dữ liệu từ Firebase
        articleRef.observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {
                let error = NSError(domain: "com.example.app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Article not found"])
                completion(.failure(error))
                return
            }

            // Parse dữ liệu từ snapshot
            guard
                let title = data["title"] as? String,
                let link = data["link"] as? String,
                let category = data["category"] as? String,
                let time = data["time"] as? String,
                let image = data["image"] as? String
            else {
                let error = NSError(domain: "com.example.app", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid article data"])
                completion(.failure(error))
                return
            }

            // Tạo đối tượng Article từ dữ liệu
            let article = Article(
                title: title,
                link: link,
                category: category,
                time: time,
                image: image
            )

            // Trả về kết quả thành công
            completion(.success(article))
        } withCancel: { error in
            // Xử lý lỗi khi truy vấn Firebase
            completion(.failure(error))
        }
    }
    func loadImageFromURLUsingSDWebImage(imageView: UIImageView, imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        // Sử dụng SDWebImage để tải ảnh từ URL
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .highPriority, completed: { (image, error, cacheType, url) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            } else {
                print("Image loaded successfully")
            }
        })
    }
}
