//
//  Patient.swift
//  BSGNProject
//
//  Created by Hùng Nguyễn on 5/11/24.
//

import Foundation
struct Patient: Codable {
    var id: String
    var name: String
    var lastName: String
    var phoneNumber: String
    var address: String
    var province: String
    var district: String
    var xa: String
    var dateOfBirth: String
    var avatar: String
    var sex: String
    var blood: String
    var identifyNumber: String
    var longitude: Double
    var latitude: Double
    var balance: Int
    var isInAppointment: Int
    var typeOfAccount: Int = 0 // Mặc định là 0 cho patient
    
    func getFullName() -> String? {
        return name + " " + lastName
    }
}
