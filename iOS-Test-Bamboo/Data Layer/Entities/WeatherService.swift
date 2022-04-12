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
    
    case getForecastByCoordinate(lat: String, lon: String, unit: Unit?)
    case getForecastByCity(city: String, unit: Unit?)
    case getIcon(code: String)
    
    var url: URL? {
        guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return nil
        }
        return _url
    }
    
    var stringValue: String {
        switch self {
        case .getForecastByCoordinate(let latitude, let longitude, let unit):
            return API_Client.base_url + "?lat=\(latitude)&lon=\(longitude)&units=\((unit != nil) ? unit!.unit : "metric")&appid=\(API_Client.appid)"
        case .getForecastByCity(let city, let unit):
            return API_Client.base_url + "?q=\(city)&units=\((unit != nil) ? unit!.unit : "metric")&appid=\(API_Client.appid)"
        case .getIcon(let code):
            return "https://openweathermap.org/img/wn/\(code)@2x.png"
        }
    }
    
    var method: HTTPMethod? {
        return .get
    }
}
