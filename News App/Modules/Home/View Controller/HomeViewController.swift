//
//  HomeViewController.swift
//  News App
//
//  Created by Deependra Dhakal on 06/12/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.requestForNews()
    }
}
