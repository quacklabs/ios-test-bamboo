//
//  WeatherDetailController.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import UIKit
import RxSwift

enum Unit: String {
    case celcius = "C"
    case fh = "F"
    
    var unit: String {
        return (self == .fh) ? "imperial" : "metric"
    }
    
    func sign() -> String {
        return "\u{00B0}\(self.rawValue)"
    }
}

class WeatherDetailController: UIViewController {
    
    lazy var cityName: UILabel = {
        let txt = UILabel()
        txt.text = "---"
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont.systemFont(ofSize: 45).bold
        return txt
    }()
    
    lazy var unitSelect : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: units)
        segmentedControl.layer.cornerRadius = 9
        segmentedControl.layer.masksToBounds = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "weather")!)
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    lazy var weatherDesc: UILabel = {
        let txt = UILabel()
        txt.textAlignment = .center
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    lazy var temperature: UILabel = {
        let txt = UILabel()
        txt.textAlignment = .center
        txt.font = UIFont.systemFont(ofSize: 45).bold
        txt.text = "---"
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    lazy var details: UILabel = {
        let txt = UILabel()
        txt.text = "DETAILS"
        txt.textColor = UIColor(hex: "#000000").withAlphaComponent(0.6)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    lazy var report: WeatherDetails = {
        let rep = WeatherDetails()
        rep.translatesAutoresizingMaskIntoConstraints = false
        return rep
    }()
    
    let units = ["C", "F"]
    var unit: Unit = .celcius
    
    let viewModel: WeatherViewModel!
    var searchType: SearchType!
    let bag = DisposeBag()
    
    init(viewModel: WeatherViewModel, type: SearchType) {
        self.viewModel = viewModel
        self.searchType = type
        super.init(nibName: nil, bundle: nil)
        self.setupView()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadSearch()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: 156).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        contentView.addViews([cityName, unitSelect])
        cityName.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: unitSelect.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        unitSelect.anchor(top: nil, leading: nil, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        
        self.navigationItem.titleView = contentView
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.view.addViews([icon, weatherDesc, temperature, details, report])
       
        unitSelect.widthAnchor.constraint(equalToConstant: 128).isActive = true
        unitSelect.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 123).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 123).isActive = true
        
        weatherDesc.anchor(top: icon.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        temperature.anchor(top: weatherDesc.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        details.anchor(top: temperature.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 0))
        report.anchor(top: details.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    
    
    private func bindData() {
        self.unitSelect.rx.value.bind { value in
            self.unit = (value == 0) ? .celcius : .fh
//            self.bindData()
            self.loadSearch()
        }.disposed(by: bag)
        
        
        self.viewModel.weather.asObservable().subscribe { (event) in
            switch event {
            case .next(let forecast):
                print("forecast: \(forecast)")
                let prediction = forecast.predictions()
                self.cityName.text = forecast.name
                self.temperature.text =  "\(forecast.main.temp) \(self.unit.sign())"
                self.loadIcon(name: forecast.weather.first!.icon)
                self.weatherDesc.text = forecast.weather.first!.main
                self.report.update(data: prediction)
            case .completed:
                return
            case .error(let error):
                self.showError(error: error.localizedDescription)
            }
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
        }.disposed(by: bag)
    }
    
    private func loadSearch() {
        var data: [String:String] = ["appid": API_Client.appid]
        switch self.searchType {
        case .city:
            data["city"] = viewModel.city!
        case .coordinate:
            data["lat"] = viewModel.latitude!
            data["lon"] = viewModel.longitude!
        default:
            break
        }
        LoadingOverlay.shared.showOverlay(view: self.view)
        self.viewModel.search(type: self.searchType, unit: self.unit, data: data)
    }
    
    private func showError(error: String) {
        let alert = UIAlertController(title: "Not Found", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            DispatchQueue.main.async {
                alert.dismiss(animated: false, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func loadIcon(name: String) {
        if let url = API_Client.weather(.getIcon(code: name)).url {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                       DispatchQueue.main.async {
                            self?.icon.image = image
                       }
                   }
                }
            }
        }
        
    }
    
    
}
