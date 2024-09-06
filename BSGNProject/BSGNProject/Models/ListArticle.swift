//
//  File.swift
//  BSGNProject
//
//  Created by Linh Thai on 27/08/2024.
//

import Foundation
struct ArticleNewResponse: Decodable {
    let status: Int
    let message: String
    let code: Int
    let data: ArticleData
}
struct ArticleData: Decodable {
    let items: [ListArticle]
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
struct ListArticle: Decodable {
    let id: Int
    let category_id: Int
    let title: String
    let slug: String
    let content: String
    let summary: String
    let picture: String
    let picture_caption: String
    let created_at: String
    let category_name: String
    let link: String
}
