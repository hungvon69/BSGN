//
//  HomeViewMoel.swift
//  BSGNProject
//
//  Created by Linh Thai on 09/09/2024.
//

import Foundation

class HomeViewModel {
    
    private var homeService: HomeService
    
    private var homeData: HomeData?
    var articleList: [Article] = []
    var promotionList: [Promotion] = []
    var doctorList: [Doctor] = []
    
    var didUpdateData: (() -> Void)?
    var didFailWithError: ((_ code: Int, _ message: String) -> Void)?
    
    init(homeService: HomeService = HomeService()) {
        self.homeService = homeService
    }
    
    private func handleSuccess(homeData: HomeData) {
        self.homeData = homeData
        self.articleList = homeData.articleList
        self.promotionList = homeData.promotionList
        self.doctorList = homeData.doctorList
        
        didUpdateData?()
    }
    
    func getArticleCount() -> Int {
        return articleList.count
    }
    
    func getPromotionCount() -> Int {
        return promotionList.count
    }
    
    func getDoctorCount() -> Int {
        return doctorList.count
    }
    
    func fetchHomeData() {
        homeService.fetchData(success: { [weak self] homeData in
            self?.handleSuccess(homeData: homeData)
        }, failure: { [weak self] code, message in
            self?.handleFailure(code: code, message: message)
        }, path: .homePath)
    }
    private func handleFailure(code: Int, message: String) {
        didFailWithError?(code, message)
    }
}

