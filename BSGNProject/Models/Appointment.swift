//
//  Appointment.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 4/11/24.
//

import Foundation
import UIKit

enum AppointmentStatus: String {
    case pending
    case confirmed
    case closed
}

struct Appointment: Codable {
    var id: String
    var doctorID: String
    var doctorName: String
    var patientID: String
    var patientName: String
    var specialty: String
    var specialtyID: Int
    var price: Int
    var date: String
    var longitude: Double
    var latitude: Double
    var position: String
    var positionNote: String
    var symtoms: String
    var status: String


    func getStatusColor() -> UIColor {
        switch status {
        case "completed": .systemGreen
        case "cancelled" : .systemRed
        default: .systemYellow
        }
    }

}
extension Appointment {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "doctorID": doctorID,
            "doctorName": doctorName,
            "patientID": patientID,
            "patientName": patientName,
            "specialtyID": specialtyID,
            "price": price,
            "date": date,
            "longitude": longitude,
            "latitude": latitude,
            "position": position,
            "positionNote": positionNote,
            "symtoms": symtoms,
            "status": status,
            "specialty": specialty
        ]
    }
}
