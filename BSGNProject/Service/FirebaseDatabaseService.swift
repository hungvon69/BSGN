//
//  FirebaseDatabaseService.swift
//  BSGNProject
//
//  Created by Khanh Vu on 25/12/24.
//

import Foundation
import FirebaseDatabase

final class FirebaseDatabaseService {
    static func fetchDoctor(by doctorID: String, completion: @escaping (Result<Doctor, Error>) -> Void) {
        let ref = Database.database().reference()
        
        // Đường dẫn tới doctorID
        let doctorRef = ref.child("users").child("doctors").child(doctorID)
        
        doctorRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(NSError(domain: "Doctor not found", code: 404, userInfo: nil)))
                return
            }
            
            do {
                // Chuyển đổi từ dictionary sang Doctor model
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let doctor = try JSONDecoder().decode(Doctor.self, from: jsonData)
                completion(.success(doctor))
            } catch {
                completion(.failure(error))
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func fetchPatient(by patientID: String, completion: @escaping (Result<Patient, Error>) -> Void) {
        let ref = Database.database().reference()
        
        // Đường dẫn tới doctorID
        let doctorRef = ref.child("users").child("patients").child(patientID)
        
        doctorRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(NSError(domain: "Doctor not found", code: 404, userInfo: nil)))
                return
            }
            
            do {
                // Chuyển đổi từ dictionary sang Doctor model
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let doctor = try JSONDecoder().decode(Patient.self, from: jsonData)
                completion(.success(doctor))
            } catch {
                completion(.failure(error))
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    static func fetchPatientHistory(for patientID: String,
                                    completion: @escaping ([Appointment]?, Error?) -> Void) {
        let ref = Database.database().reference()
        
        let appointmentsRef = ref.child("appointments")
        
        // Query appointments with the matching patientID
        appointmentsRef.queryOrdered(byChild: "patientID").queryEqual(toValue: patientID).observeSingleEvent(of: .value) { snapshot in
            var appointments: [Appointment] = []
            
            if let value = snapshot.value as? [String: Any] {
                for (_, appointmentData) in value {
                    if let appointmentDict = appointmentData as? [String: Any] {
                        do {
                            // Convert dictionary to Appointment object
                            let jsonData = try JSONSerialization.data(withJSONObject: appointmentDict, options: [])
                            let appointment = try JSONDecoder().decode(Appointment.self, from: jsonData)
                            appointments.append(appointment)
                        } catch {
                            print("Failed to decode appointment: \(error.localizedDescription)")
                            completion(nil, error)
                            return
                        }
                    }
                }
                completion(appointments, nil)
            } else {
                completion(nil, nil) // No appointments found
            }
        } withCancel: { error in
            print("Error fetching appointments: \(error.localizedDescription)")
            completion(nil, error)
        }
    }

}
