//
//  Doctor.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import Foundation
struct Doctor: Decodable {
    let id: Int
    let full_name: String
    let name: String
    let last_name: String
    let contact_email: String
    let phone: String
    let avatar: String
    let majors_name: String
    let ratio_star: Double
    let number_of_reviews: Int
    let number_of_stars: Int
}
