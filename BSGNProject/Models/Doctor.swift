//
//  Doctor.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

struct Doctor: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var education: String
    var phoneNumber: String
    var avatar: String
    var majorID: Int
    var district: String
    var degree: String
    var gender: String
    var address: String
    var isInAppointment: Int
    var typeOfAccount: Int = 1 // Mặc định là 1 cho doctor
    var price: Int
    var balance: Int
    var major: String
    var training_place: String
    
    func getFullName() -> String? {
        return firstName + " " + lastName
    }
}
