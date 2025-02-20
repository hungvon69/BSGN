//
//  ArticleViewModel.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//

import Foundation
import UIKit

class ArticleViewModel {
    var articles: [Article] = []
    var listArticle: [ListArticle] = []
    var articleImages: [Int: UIImage] = [:]
    let homeService = HomeService()
    var count: Int {
        
        return articles.count
    }

    func article(at index: Int) -> Article {
        return articles[index]
    }
}
