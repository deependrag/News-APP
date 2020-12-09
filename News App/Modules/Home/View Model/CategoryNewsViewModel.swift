//
//  CategoryNewsViewModel.swift
//  News App
//
//  Created by Deependra Dhakal on 07/12/2020.
//

import UIKit
import SkeletonView

enum NewsCategory : Int, CaseIterable {
    case all
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
    
    var description: String{
        switch self {
        case .all:
            return "All Feeds"
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

enum MessageType {
    case success(message: String)
    case error(message: String)
}

class CategoryNewsViewModel {
    
    private var responseModel : NewsResponseModel?
    
    private var articles = [Articles]()
    
    private var category : NewsCategory
    
    let cellIdentifier = "ArticleTableViewCell"
    let bigBannerArticleTableViewCell = "BigBannerArticleTableViewCell"
    
    //Pagination
    private var page = 1
    private var total = 0
    private var isFetchInProgress = false
    
    //Passing data to view
    let dynamicReloadRows: Dynamic<[IndexPath]?> = Dynamic(nil)
    let displayMessage: Dynamic<MessageType?> = Dynamic(nil)
    
    init(newsCategory: NewsCategory) {
        self.category = newsCategory
    }
    
    var tabTitle: String {
        return category.description
    }
    
    var currentCount: Int {
        return articles.count
    }

    
    func numberOfRowsInSection(section: Int) -> Int {
        return (isFetchInProgress && (page == 1)) ? 6 :  total
    }
    
    func cellForRow(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: bigBannerArticleTableViewCell, for: indexPath) as! BigBannerArticleTableViewCell
            cell.selectionStyle = .none
            
            if isLoadingCell(for: indexPath) {
                cell.showSkeleton()
            }else {
                cell.hideSkeleton()
                cell.updateUI(model: self.articles[indexPath.row])
            }
            
            return cell

        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ArticleTableViewCell
            cell.selectionStyle = .none
            
            if isLoadingCell(for: indexPath) {
                cell.showSkeleton()
            }else {
                cell.hideSkeleton()
                cell.updateUI(model: self.articles[indexPath.row])
            }
            
            return cell
        }
        
    }
    
    
    func heightFor(indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        return UITableView.automaticDimension
    }
    
    func didSelectRow(indexPath : IndexPath) -> String? {
        guard articles.count - 1 >= indexPath.row else {return nil}
        return self.articles[indexPath.row].url ?? ""
    }
    
    private func calculateIndexPathsToReload(from newModerators: [Articles]) -> [IndexPath] {
        let productCount = self.articles.count
        let startIndex = productCount - newModerators.count
        let endIndex = startIndex + newModerators.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
      return indexPath.row >= self.currentCount
    }
    
    func cellIdentifier(for indexPath : IndexPath) -> String {
        return cellIdentifier
    }
    
    func clearPagination() {
        self.page = 1
        self.articles = []
    }
    
    //Send GET Request to fetch news
    func requestForHeadLines() {
        guard !isFetchInProgress else {
          return
        }
        
        isFetchInProgress = true
        
        var params : [String : String] = [
            "language" : "en",
            "page" : "\(page)"
        ]
        
        if self.category != .all {
            params["category"] = self.category.description
        }
        
        APIClient.shared.fetch(with: APIService.topHeadlines(params: params).request) { [weak self] (result: Result<NewsResponseModel?, APIError>) in
            guard let `self` = self else {return}
            self.isFetchInProgress = false
            
            switch result {
            case .success(let data):
                
                self.total = data?.totalResults ?? 0
                
                self.responseModel = data
                
                self.articles.append(contentsOf: data?.articles ?? [])
                
                if self.total > self.currentCount && self.page != 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: data?.articles ?? [])
                    self.dynamicReloadRows.value = indexPathsToReload
                }else {
                    self.dynamicReloadRows.value = nil
                }
                
                self.page += 1
                
            case .failure(let error):
                print("Failed: \(error.localizedDescription)")
                self.displayMessage.value = .error(message: error.localizedDescription)
            }
        }
    }
}
