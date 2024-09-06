//
//  BaseService2.swift
//  BSGNProject
//
//  Created by Linh Thai on 17/08/2024.
//

import Foundation
import Alamofire

class BaseService {
    // Phương thức để gửi yêu cầu và xử lý phản hồi JSON
    static func request<T: Decodable>(url: String, responseType: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                // In ra lỗi chi tiết để dễ dàng gỡ lỗi
                print("Error fetching data: \(error.localizedDescription)")
                if let underlyingError = error.underlyingError {
                    print("Underlying error: \(underlyingError)")
                }
                if let data = response.data {
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                }
                completion(.failure(error))
            }
        }
    }
}
