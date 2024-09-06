//
//  HomeService2.swift
//  BSGNProject
//
//  Created by Linh Thai on 17/08/2024.
//

import Foundation
import Alamofire

class NewsService: BaseService {
    static func fetchNews(completion: @escaping (Result<HomeData, AFError>) -> Void) {
        let url = "https://gist.githubusercontent.com/hdhuy179/f967ffb777610529b678f0d5c823352a/raw"
        request(url: url, responseType: APINewResponse.self) { result in
            switch result {
            case .success(let newsResponse):
                completion(.success(newsResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
struct APINewResponse: Decodable {
    let status: Int
    let message: String
    let code: Int
    let data: HomeData
    
}

