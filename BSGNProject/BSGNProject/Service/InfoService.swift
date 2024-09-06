//
//  InfoService.swift
//  BSGNProject
//
//  Created by Linh Thai on 29/08/2024.
//

import Foundation
import Alamofire
class InfoService: BaseService {
    static func fetchNews(completion: @escaping (Result<User, AFError>) -> Void) {
        let url = "https://gist.githubusercontent.com/CanThaiLinh/00762adf68d2dddf0aea6396fd1b153a/raw"
        request(url: url, responseType: InfoNewResponse.self) { result in
            switch result {
            case .success(let newsResponse):
                completion(.success(newsResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
