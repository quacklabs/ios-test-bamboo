//
//  HomeViewController.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var weatherTable: UITableView = {
        let tbl = UITableView()
        return tbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
        title = "Welcome"
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
    }
    
}
