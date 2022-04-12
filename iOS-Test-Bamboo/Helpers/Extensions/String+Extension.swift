//
//  String+Extension.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import Foundation

extension String {
    var length: Int {
        return self.count
    }

    func substring(_ from: Int, _ length: Int? = nil) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return (length != nil && self.length > 0) ? String(self[fromIndex ..< self.index(fromIndex, offsetBy: length!)]) : String(self[fromIndex...])
    }
}
