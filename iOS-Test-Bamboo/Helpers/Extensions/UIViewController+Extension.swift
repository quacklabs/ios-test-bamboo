//
//  UIViewController+Extension.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//
import UIKit

extension UIViewController {
    func wrapInNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
