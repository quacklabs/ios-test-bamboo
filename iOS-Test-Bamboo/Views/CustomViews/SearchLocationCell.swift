//
//  SearchLocationCell.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import UIKit

class SearchLocationCell: UITableViewCell {
    
    static let identifier = "SearchLocation"
    
    lazy var txtField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.addSubview(txtField)
        txtField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func configure(placeholder: String) {
        self.txtField.placeholder = placeholder
    }
}
