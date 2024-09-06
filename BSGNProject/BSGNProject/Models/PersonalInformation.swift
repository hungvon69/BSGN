//
//  PersonalInformation.swift
//  BSGNProject
//
//  Created by Linh Thai on 29/08/2024.
//

import Foundation
struct User: Codable {
    let id: Int
    let name: String
    let last_name: String
    let username: String
    let contact_email: String
    let phone: String
    let card_id: String
    let address: String
    let province_code: String
    let district_code: String
    let ward_code: String
    let latitude: Double
    let longitude: Double
    let birth_date: String
    let avatar: String
    let degree: String
    let training_place: String
    let academic_rank: String
    let majors_id: Int
    let hospital_name: String
    let sex: Int
    let blood: Int
    let description_self: String
    let verified_at: String
    let current_step: Int
    let user_type: Int
    let refer_code: String
    let working_hour_type: Int
    let balance: Int
    let ratio_star: Double
    let number_of_reviews: Int
    let number_of_stars: Int
    let status: Int
    let is_first_login: Int
    let created_at: String
    let updated_at: String
    let full_address: String
    let full_name: String
    let order_cancel_total: Int
    let referral_total: Int
    let blood_name: String
    let total_appointment: Int
}
struct InfoNewResponse: Codable {
    let status: Int
    let message: String
    let code: Int
    let data: User
}
