//
//  Forecast.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import Foundation


struct Forecast: Codable {
    var coord: Cordinates
    var weather: [Weather]
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var dt: String
    var sys: System
    var timezone: Int64 //-25200,
    var id: Int64 //420006353,
    var name: String //"Mountain View",
    var cod: Int //200
    
    enum CodingKeys: String, CodingKey {
        case coord, weather, base, main, visibility, clouds, dt, sys, timezone, name
        case id, cod, wind
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        
        coord = try values.decode(Cordinates.self, forKey: .coord)
        weather = try values.decode([Weather].self, forKey: .weather)
        base = try values.decode(String.self, forKey: .base)
        main = try values.decode(Main.self, forKey: .main)
        visibility = try values.decode(Int.self, forKey: .visibility)
        wind = try values.decode(Wind.self, forKey: .wind)
        clouds = try values.decode(Clouds.self, forKey: .clouds)
        dt = try values.decode(String.self, forKey: .dt)
        sys = try values.decode(System.self, forKey: .sys)
        timezone = try values.decode(Int64.self, forKey: .timezone)
        id = try values.decode(Int64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        cod = try values.decode(Int.self, forKey: .cod)
    }
}



struct System: Codable {
    var type: Int
    var id: Int //5122,
    var message: Float //0.0139,
    var country: String //"US",
    var sunrise: Int64 //1560343627,
    var sunset: Int64 //1560396563
}

struct Clouds: Codable {
    var all: Int
}

struct Wind: Codable {
    var speed: Double
    var deg: Double
}

struct Main: Codable {
    var temp: Double //282.55,
    var feels_like: Double //281.86,
    var temp_min: Double //280.37,
    var temp_max: Double //284.26,
    var pressure: Int //1023,
    var humidity: Int //100
}

struct Cordinates: Codable {
    var lat: String
    var lon: String
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

