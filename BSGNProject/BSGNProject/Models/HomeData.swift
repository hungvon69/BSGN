//
//  HomeData.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import Foundation
struct HomeData: Decodable {
    let articleList: [Article]
    let promotionList: [Promotion]
    let doctorList: [Doctor]
}
