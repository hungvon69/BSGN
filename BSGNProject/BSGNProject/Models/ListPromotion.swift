//
//  ListPromotion.swift
//  BSGNProject
//
//  Created by Linh Thai on 27/08/2024.
//

import Foundation

struct PromotionNewResponse: Decodable {
    let status: Int
    let message: String
    let code: Int
    let data: PromotionData
}
struct PromotionData: Decodable {
    let items: [ListPromotion]
    let totalRecord: Int
    let totalPage: Int
    let page: Int

    enum CodingKeys: String, CodingKey {
        case items
        case totalRecord = "total_record"
        case totalPage = "total_page"
        case page
    }
}
struct ListPromotion: Decodable {
    let id: Int
    let categoryId: Int
    let code: String
    let name: String
    let slug: String
    let content: String
    let picture: String
    let fromDate: String
    let toDate: String
    let amount: Int
    let type: Int
    let kind: Int
    let createdAt: String
    let categoryName: String
    let link: String
    let typeName: String
    let amountText: String
    let isBookmark: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case code
        case name
        case slug
        case content
        case picture
        case fromDate = "from_date"
        case toDate = "to_date"
        case amount
        case type
        case kind
        case createdAt = "created_at"
        case categoryName = "category_name"
        case link
        case typeName = "type_name"
        case amountText = "amount_text"
        case isBookmark = "is_bookmark"
    }
}



