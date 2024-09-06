//
//  ListDoctorService.swift
//  BSGNProject
//
//  Created by Linh Thai on 27/08/2024.
//

import Foundation
import Alamofire

class DoctorService: BaseService {
    static func fetchNews(completion: @escaping (Result<DoctorData, AFError>) -> Void) {
        let url = "https://gist.githubusercontent.com/CanThaiLinh/c166341bf5c5a1f9f417656598013bc9/raw/05770dbe98b1e9d0e14ab23ef4cea3fce5e90e80/gistfile1.txt"
        request(url: url, responseType: DoctorNewResponse.self) { result in
            switch result {
            case .success(let newsResponse):
                completion(.success(newsResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
