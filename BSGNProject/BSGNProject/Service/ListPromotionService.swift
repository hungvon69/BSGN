//
//  ListPromotionService.swift
//  BSGNProject
//
//  Created by Linh Thai on 27/08/2024.
//

import Foundation
import Alamofire

class PromotionService: BaseService {
    static func fetchNews(completion: @escaping (Result<PromotionData, AFError>) -> Void) {
        let url = "https://gist.githubusercontent.com/CanThaiLinh/a373bfb717cb25a5fa4a1017995847eb/raw"
        request(url: url, responseType: PromotionNewResponse.self) { result in
            switch result {
            case .success(let newsResponse):
                completion(.success(newsResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
