//
//  API_Client.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import Foundation
import Alamofire

protocol Microservice {
    var url: URL? { get }
    var stringValue: String { get }
    var method: HTTPMethod? { get }
}

enum API_Client: Microservice {
    
    static let base_url = "https://api.openweathermap.org/data/2.5/weather"
    static let appid = "59d32ec8b2d693c2914ede573815b527" // for test purpose only, this should be in a config file on production
    
    case weather(WeatherService)
    
    var stringValue: String {
        switch self {
        case .weather(let route):
            return route.stringValue
        }
    }
    
    var url : URL? {
         guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
                    return nil
        }
        return _url
    }
    
    // for when multiple route define their own http methods
    // will be returning nil for now
    var method: HTTPMethod? { return nil }
}
