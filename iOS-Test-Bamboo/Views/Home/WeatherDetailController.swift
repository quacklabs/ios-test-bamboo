//
//  WeatherDetailController.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import UIKit
import RxSwift

class WeatherDetailController: UIViewController {
    
    lazy var cityName: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 16).bold
        return txt
    }()
    
    lazy var unitSelect : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: units)
        segmentedControl.layer.cornerRadius = 9
        segmentedControl.layer.masksToBounds = true
        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.tintColor = Colors.darkerBlue
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        segmentedControl.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
//        segmentedControl.superview?.backgroundColor = Colors.lighterBlue
        
        return segmentedControl
    }()
    let units = ["C", "F"]
    
    let viewModel: WeatherViewModel!
    var searchType: SearchType!
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.view.addViews([cityName, unitSelect])
    }
    
    private func bindData() {
        
        self.unitSelect.rx.value.bind { value in
            
        }.disposed(by: viewModel.disposeBag)
        
        self.viewModel.weather.subscribe { (event) in
            switch event {
            case .next(let forcast):
                return
            case .completed:
                return
            case .error(let error):
                return
            }
        }.disposed(by: viewModel.disposeBag)
    }
    
    
}
