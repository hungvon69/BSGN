//
//  Promotion.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import Foundation
struct Promotion: Decodable {
    let id: Int
    let category_id: Int
    let code: String
    let name: String
    let slug: String
    let content: String
    let picture: String
    let from_date: String
    let to_date: String
    let amount: Int
    let type: Int
    let kind: Int
    let created_at: String
    let category_name: String
    let amount_text: String
    let link: String
    let is_bookmark: Bool
}
