//
//  CategoryNewsViewController.swift
//  News App
//
//  Created by Deependra Dhakal on 07/12/2020.
//

import UIKit
import XLPagerTabStrip
import SkeletonView

class CategoryNewsTableViewController: UITableViewController, IndicatorInfoProvider, SkeletonTableViewDataSource {
    
    var viewModel : CategoryNewsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        bindViewToViewModel()
        viewModel.requestForHeadLines()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: viewModel.tabTitle.capitalizingFirstLetter())
    }
    
    func setupView() {
        registerNIB()
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .none
        self.tableView.prefetchDataSource = self
        self.tableView.contentInset.bottom = 20
        self.view.backgroundColor = .white
        
    }
    
    func registerNIB() {
        self.tableView.register(UINib(nibName: viewModel.cellIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.cellIdentifier)
        self.tableView.register(UINib(nibName: viewModel.bigBannerArticleTableViewCell, bundle: nil), forCellReuseIdentifier: viewModel.bigBannerArticleTableViewCell)
    }
    
    func bindViewToViewModel() {
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        
        viewModel.dynamicReloadRows.bindAndFire {[weak self] (indexpath) in
            guard let newIndexPathsToReload = indexpath,
                  let strongSelf = self else {
                self?.tableView.reloadData()
              return
            }
            
            let indexPathsToReload = strongSelf.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
            DispatchQueue.main.async {
                strongSelf.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            }
        }
        
        viewModel.displayMessage.bindAndFire {[weak self] (messageType) in
            guard let type = messageType,
                  let strongSelf = self
            else {return}
            
            switch type {
            case .error(message: let message):
                strongSelf.showAlert(title: "Error", message: message, buttonTitle: "ok")
            case .success(message: let message):
                strongSelf.showAlert(title: "Success", message: message, buttonTitle: "ok")
            }
           
        }
    }
    
    
    
    @objc func dismissViewTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshControlAction() {
        self.viewModel.clearPagination()
        self.viewModel.requestForHeadLines()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    //MARK:- Navigation
    func moveToDetailsView(with urlStr: String) {
        let newsDetailsVC = NewsDetailsViewController()
        newsDetailsVC.newsUrl = urlStr
        self.navigationController?.pushViewController(newsDetailsVC, animated: true)
    }

    // MARK: - Table view delegate and data source

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return viewModel.cellIdentifier(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(tableView: tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightFor(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightFor(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let link = viewModel.didSelectRow(indexPath: indexPath) else {return}
        self.moveToDetailsView(with: link)
    }
}

//MARK:- Prefetch Data
extension CategoryNewsTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoadingCell) {
            viewModel.requestForHeadLines()
        }
    }
}

private extension CategoryNewsTableViewController {
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPaths).intersection(indexPathsForVisibleRows)
    return Array(indexPathsIntersection)
  }
}
