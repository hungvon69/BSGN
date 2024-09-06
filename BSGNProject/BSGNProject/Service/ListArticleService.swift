//
//  ListArticleService.swift
//  BSGNProject
//
//  Created by Linh Thai on 27/08/2024.
//

import Foundation
import Alamofire

class ArticleService: BaseService {
    static func fetchNews(completion: @escaping (Result<ArticleData, AFError>) -> Void) {
        let url = "https://gist.githubusercontent.com/CanThaiLinh/54afd6bc6efe3098f4480bf19a3739d2/raw/4ae4d392da6eb72bb500e61f69c3d3b8ab5ff8db/gistfile1.txt"
        request(url: url, responseType: ArticleNewResponse.self) { result in
            switch result {
            case .success(let newsResponse):
                completion(.success(newsResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
