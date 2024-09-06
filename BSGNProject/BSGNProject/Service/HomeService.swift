//
//  HomeService.swift
//  BSGNProject
//
//  Created by Linh Thai on 16/08/2024.
//
import Foundation
class HomeService: BaseService3 {
    
    func fetchHomeData(success: @escaping (HomeData) -> Void, failure: @escaping (_ code: Int, _ message: String) -> Void) {
        request("https://gist.githubusercontent.com/hdhuy179/f967ffb777610529b678f0d5c823352a/raw", .get, of: HomeData.self, success: { response in
            success(response)
            print(response.articleList.count)
        }, failure: { code, message in
            failure(code, message)
            print("ERROR \(code): \(message)")
        })
    }
}
