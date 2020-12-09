//
//  HomeViewController.swift
//  News App
//
//  Created by Deependra Dhakal on 06/12/2020.
//

import UIKit
import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {
    
    let containerScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let topBarView: ButtonBarView = {
        let view = ButtonBarView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    override func viewDidLoad() {
        setupSlidingTab()
        super.viewDidLoad()

    }
    
    //Configure different category viewcontrollers
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        return NewsCategory.allCases.map { (category) -> UIViewController in
            let vc = CategoryNewsTableViewController()
            vc.viewModel = CategoryNewsViewModel(newsCategory: category)
            return vc
        }
    }
    
    // MARK: - PagerTabStrip View Setup
    private func setupSlidingTab(){
        
        //Set View Controller Title
        self.title = "News"
        
        //Setup Tab bar
        self.containerView = self.containerScrollView
        self.buttonBarView = self.topBarView
        
        self.view.addSubview(self.topBarView)
        self.view.addSubview(self.containerScrollView)
        NSLayoutConstraint.activate([
            self.topBarView.heightAnchor.constraint(equalToConstant: 44),
            self.topBarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: self.topBarView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.containerScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: self.containerScrollView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.topBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.containerScrollView.topAnchor.constraint(equalTo: self.topBarView.bottomAnchor, constant: 0),
            self.view.bottomAnchor.constraint(equalTo: self.containerScrollView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        //Styling tabbar
        settings.style.buttonBarBackgroundColor = .primaryColor
        settings.style.buttonBarItemBackgroundColor = .primaryColor
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.white.withAlphaComponent(0.5)
            newCell?.label.textColor = .white
        }
        
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
    }
    
}
