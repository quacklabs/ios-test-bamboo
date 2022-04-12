//
//  WeatherService.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherService: Microservice {
    
    case getForcast(lat: String, lon: String)
    case getIcon(code: String)
    
    var url: URL? {
        guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return nil
        }
        return _url
    }
    
    var stringValue: String {
        switch self {
        case .getForcast(let latitude, let longitude):
            return API_Client.base_url + "?lat=\(latitude)&lon=\(longitude)&appid=\(API_Client.appid)"
        case .getIcon(let code):
            return "http://openweathermap.org/img/wn/\(code)@2x.png"
        }
    }
    
    var method: HTTPMethod? {
        return .get
    }
}
