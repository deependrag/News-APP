//
//  HomeViewModel.swift
//  News App
//
//  Created by Deependra Dhakal on 06/12/2020.
//

import UIKit

enum AllCategories : Int, CaseIterable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
    
    var description: String{
        switch self {
        
        case .general:
            return "general"
        case .business:
            return "business"
        case .entertainment:
            return "entertainment"
        case .health:
            return "health"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .technology:
            return "technology"
        }
    }
}

class HomeViewModel{
    
    private var newsResponseModel : NewsResponseModel?
    
    //Cell Identifier
    let newsTableViewCell = "NewsTableViewCell"
    
//    func numberOfRowsInSection(section: Int) -> Int {
//        return newsResponseModel?.sources?.count ?? 0
//    }
//
//    func cellForRow(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: newsTableViewCell, for: indexPath) as! NewsTableViewCell
//        cell.selectionStyle = .none
//        if isLoading.value {
//            cell.showSkeleton()
//        }else {
//            cell.hideSkeleton()
//            cell.updateUI(with: self.wishListResponseModel?[indexPath.row])
//        }
//
//        return cell
//    }
//
//    func heightFor(indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func didSelectRow(indexPath : IndexPath) {
//        if let productID = self.wishListResponseModel?[indexPath.row].productIDWishlist {
//            self.productDetailsNavigator.onNext(productID)
//        }
//    }
//
//
//    func cellIdentifier(for indexPath : IndexPath) -> String {
//        return wishListTableViewCell
//    }
//
//    private func updateTableViewBackground() {
//        if let wishListItems = self.wishListResponseModel {
//            if wishListItems.count == 0 {
//                self.tableViewBackground.accept(.noData(title: "Hey, it feels so empty", message: "There is nothing in your wishlist. Let\'s add some items", alighment: .center))
//            }else {
//                self.tableViewBackground.accept(.empty)
//            }
//        }
//    }
    
    func requestForNews() {
        
        let params : [String : String] = [
            "language" : "en"
        ]
        
        APIClient.shared.fetch(with: APIService.topHeadlines(params: params).request) { [unowned self] (result: Result<NewsResponseModel?, APIError>) in
            
            switch result {
            case .success(let data):
                self.newsResponseModel = data
            case .failure(let error):
                print("Failed: \(error.localizedDescription)")
            }
        }
    }
}
