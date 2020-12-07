//
//  CategoryNewsViewModel.swift
//  News App
//
//  Created by Deependra Dhakal on 07/12/2020.
//

import Foundation
class CategoryNewsViewModel {
    
    private var responseModel : NewsResponseModel?
    
    private var articles = [Articles]()
    
    init(newsCategory: AllCategories) {
        
    }
    
    
    
    func requestForHeadLines() {
        
        let params : [String : String] = [
            "language" : "en"
        ]
        
        APIClient.shared.fetch(with: APIService.topHeadlines(params: params).request) { [unowned self] (result: Result<NewsResponseModel?, APIError>) in
            
            switch result {
            case .success(let data):
                self.responseModel = data
            case .failure(let error):
                print("Failed: \(error.localizedDescription)")
            }
        }
    }
}
