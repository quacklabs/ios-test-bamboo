//
//  Forecast.swift
//  iOS-Test-Bamboo
//
//  Created by Mark Boleigha on 11/04/2022.
//  Copyright © 2022 bambooo. All rights reserved.
//

import Foundation
//{
//base = stations;
//clouds =     {
//    all = 75;
//};
//cod = 200;
//coord =     {
//    lat = "43.7001";
//    lon = "-79.41630000000001";
//};
//dt = 1649753779;
//id = 6167865;
//main =     {
//    "feels_like" = "279.53";
//    humidity = 66;
//    pressure = 1014;
//    temp = "281.66";
//    "temp_max" = "282.81";
//    "temp_min" = "280.1";
//};
//name = Toronto;
//sys =     {
//    country = CA;
//    id = 718;
//    sunrise = 1649759981;
//    sunset = 1649807803;
//    type = 1;
//};
//timezone = "-14400";
//visibility = 10000;
//weather =     (
//            {
//        description = "broken clouds";
//        icon = 04n;
//        id = 803;
//        main = Clouds;
//    }
//);
//wind =     {
//    deg = 310;
//    gust = "7.72";
//    speed = "3.6";
//};

struct Forecast: Codable {
    var coord: Cordinates
    var weather: [Weather]
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var dt: Double?
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
        dt = try values.decodeIfPresent(Double.self, forKey: .dt)
        sys = try values.decode(System.self, forKey: .sys)
        timezone = try values.decode(Int64.self, forKey: .timezone)
        id = try values.decode(Int64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        cod = try values.decode(Int.self, forKey: .cod)
    }
    
    func predictions() -> [Prediction] {
        var list = [Prediction]()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        
        let sunrise = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sys.sunrise)))
        let sunset = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.sys.sunset)))
        
        list.append(Prediction(name: "Min temperature", value: String(self.main.temp_min)))
        list.append(Prediction(name: "Max temperature", value: String(self.main.temp_max)))
        list.append(Prediction(name: "Cloud coverage", value: "\(self.clouds.all)%"))
        list.append(Prediction(name: "Latitude", value: "\(self.coord.lat)"))
        list.append(Prediction(name: "Longitude", value: "\(self.coord.lon)"))
        list.append(Prediction(name: "Cloud coverage", value: "\(self.clouds.all)%"))
        list.append(Prediction(name: "Sunrise", value: "\(sunrise)"))
        list.append(Prediction(name: "Sunset", value: "\(sunset)"))
        return list
    }
}



struct System: Codable {
    var type: Int
    var id: Int //5122,
    var message: Float? //0.0139,
    var country: String //"US",
    var sunrise: Int64 //1560343627,
    var sunset: Int64 //1560396563
}

struct Clouds: Codable {
    var all: Int
}

struct Wind: Codable {
    var speed: Double
    var gust: Double?
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
    var lat: Double
    var lon: Double
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

