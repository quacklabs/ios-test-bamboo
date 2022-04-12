//
//  WeatherDetails.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 12/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import UIKit


class WeatherDetails: UIStackView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.distribution = .fillEqually
        self.autoresizesSubviews = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(data: [Prediction]) {
        self.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        data.forEach { self.createDetail(prediction: $0) }
    }
    
    func createDetail(prediction: Prediction) {
        let detailView = DetailView(name: prediction.name, value: prediction.value)
        self.addArrangedSubview(detailView)
    }
}


class DetailView: UIView {
    
    let nameLabel = UILabel()
    let valueLabel = UILabel()
    
    private let name: String!
    private let value: String!
    
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.systemFont(ofSize: 16).bold
        valueLabel.font = UIFont.systemFont(ofSize: 16).bold
        
        self.addViews([nameLabel, valueLabel])
        nameLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: valueLabel.leadingAnchor, padding: UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 5))
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        valueLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self.addBorder(.bottom, color: .black, thickness: 0.2)
        
        nameLabel.text = name
        valueLabel.text = value
    }
}
