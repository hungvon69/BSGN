//
//  HomeService.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//
import Foundation
import Alamofire
enum HomePath: String{
    case articlePath
    case promotionPath
    case doctorPath
    case homePath
    var endpoint: String {
        switch self {
        case .articlePath:
                return "54afd6bc6efe3098f4480bf19a3739d2/raw"
        case .promotionPath:
                return "a373bfb717cb25a5fa4a1017995847eb/raw"
        case .doctorPath:
            return "c166341bf5c5a1f9f417656598013bc9/raw/05770dbe98b1e9d0e14ab23ef4cea3fce5e90e80/gistfile1.txt"
        case .homePath:
            return "9ae4d163772ff5c07f8207649a2c6336/raw"
        }
    }
}

class HomeService: BaseService3 {
    
    func fetchData<T: Decodable>(success: @escaping (T) -> Void,
                   failure: @escaping (_ code: Int, _ message: String) -> Void, path: HomePath) {
        let endpoint = path.endpoint
                
        request(endpoint, .get, of: T.self, success: { response in
            success(response)
            print("======1======")
        }, failure: { code, message in
            failure(code, message)
            print("ERROR \(code): \(message)")
        })
    }
}
