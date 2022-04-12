//
//  SelectCityTableCell.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import UIKit

class SelectCityTableCell: UITableViewCell {
    static let identifier = "SelectCity"
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "right")!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var city: String!
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        self.addSubview(label)
        self.addSubview(icon)
        label.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    func configure(name: String) {
        self.label.text = name
        self.city = name
    }
}
