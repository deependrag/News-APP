//
//  NewsDetailsViewController.swift
//  News App
//
//  Created by Deependra Dhakal on 07/12/2020.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController {
    
    lazy var newsWebView : WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isSkeletonable = true
        webView.skeletonCornerRadius = 16
        return webView
    }()
    
    lazy var spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.tintColor = .primaryColor
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    var newsUrl : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Details"
        setupView()
        loadWebUrl()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(newsWebView)
        self.view.addSubview(spinner)
        
        newsWebView.navigationDelegate = self
        
        NSLayoutConstraint.activate([
            newsWebView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            newsWebView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            newsWebView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            newsWebView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            
            spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func loadWebUrl() {
        guard let newsUrlStr = self.newsUrl,
              let newsUrl = URL(string: newsUrlStr)
        else {return}
        
        self.newsWebView.load(NSURLRequest(url: newsUrl) as URLRequest)
    }
}

extension NewsDetailsViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
}
