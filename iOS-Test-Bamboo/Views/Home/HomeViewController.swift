//
//  HomeViewController.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa


class HomeViewController: UIViewController {
    
    lazy var weatherTable: UITableView = {
        let tbl = UITableView()
        tbl.backgroundColor = UIColor(hex: "#EFEFF4")
        tbl.register(SelectCityTableCell.self, forCellReuseIdentifier: SelectCityTableCell.identifier)
        tbl.register(SearchLocationCell.self, forCellReuseIdentifier: SearchLocationCell.identifier)
        tbl.allowsMultipleSelection = false
        return tbl
    }()
    
    lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hex: "#007AFF")
        btn.setTitle("Search", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    private let bag = DisposeBag()
    let viewModel = WeatherViewModel()
    
    let sections: [MultipleSectionModel] = [
        .SelectCitySection(title: "CHOOSE A CITY", items: [.SelectCityItem(name: "Delhi"), .SelectCityItem(name: "Berlin"), .SelectCityItem(name: "Toronto")]),
        .SearchLocationSection(title: "SEARCH A LOCATION", items: [.SearchLocationSectionItem(title: "Latitude"), .SearchLocationSectionItem(title: "Longitude")]),
        .SearchCitySection(title: "SEARCH A CITY", items: [.SearchCityItem(title: "City Name")])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialize()
        bind()
        
    }
    
    private func initialize() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Welcome"
        view.backgroundColor = .white
        
        self.view.addSubview(weatherTable)
        weatherTable.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
    }
    
    private func bind() {
        let dataSource = viewModel.dataSource()
        weatherTable.rx.setDelegate(self).disposed(by: bag)
        
        Observable.just(self.sections).bind(to: weatherTable.rx.items(dataSource: dataSource)).disposed(by: bag)
        searchButton.rx.tap.bind { [weak self] in
            self?.validateAndContinue()
        }.disposed(by: bag)
    }
    
    func validateAndContinue() {
        
        // validate that city is not null, then search by city
        if self.viewModel.city != nil && self.viewModel.city != "" {
            showWeather(searchType: .city)
        } else {
            // city is null or empty, validate that longitude and latitude are set
            guard self.viewModel.latitude != "", self.viewModel.longitude != "" else {
                self.showAlert(message: "Enter a city name or coordinates")
                return
            }
            showWeather(searchType: .coordinate)
        }
        
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func showWeather(searchType: SearchType) {
        let controller = WeatherDetailController(viewModel: self.viewModel, type: searchType)
        self.navigationController?.pushViewController(controller, animated: false)
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 100
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 2 else { return nil }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 73))
        footerView.addSubview(searchButton)
        searchButton.anchor(top: footerView.topAnchor, leading: footerView.leadingAnchor, bottom: footerView.bottomAnchor, trailing: footerView.trailingAnchor, padding: UIEdgeInsets(top: 17, left: 16, bottom: 16, right: 16))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor(hex: "#000000").withAlphaComponent(0.5)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt index: IndexPath) {
        guard index.section == 0, let cell = tableView.cellForRow(at: index) as? SelectCityTableCell else { return }
        
        viewModel.city = cell.city!
        self.showWeather(searchType: .city)
    }
}
